using bank_documents_parser;
using System.Reflection;
using System.Text;
using System.Text.Json;

var context = "main";
var appSettings = default(AppSettings);

var jsonOptions = new JsonSerializerOptions 
{
	PropertyNameCaseInsensitive = true,
	WriteIndented = true,
	PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    AllowTrailingCommas = true,
    ReadCommentHandling = JsonCommentHandling.Skip,
};

var PaymentsSqlTableName = "import_raw";
var PaymentsSqlTableCreateScript = $@"############## TABLE CREATION BELOW

#drop table if exists {PaymentsSqlTableName};

create table if not exists {PaymentsSqlTableName}
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_index int not null,
    payment_date date not null,
    is_credit bool not null,
    amount decimal(8,2) not null,
    vs int(10) null,
    origin varchar(100) not null,
    payer_iban varchar(24) null,
    payer_name nvarchar(100) null,
    detail nvarchar(100) null,
    payment_id varchar(30) null,
    bank_ref varchar(50) null,
    payer_ref varchar(50) null,
    payment_source mediumtext null
);

########## DATA INSERTION BELOW

#### possible problem max query size, if so run the following statement:
#set global mysqlx_max_allowed_packet = 1073741824;

insert into {PaymentsSqlTableName} values

";

try
{
    var workDir = GetWorkingDirectory();

    if (!Directory.Exists(workDir))
    {
        Directory.CreateDirectory(workDir);
        Log.Raw($"Creating new working directory {workDir}...");
    }

    Log.Raw(new string('*', 120));
    Log.Raw();
    Log.Raw("-----------------------");
    Log.Raw("Starting...");
    Log.Raw("-----------------------");

    var appDir = GetCurrentPath();
    var configPath = GetConfigPath();
    appSettings = CreateAndReadConfigFile(jsonOptions, configPath, appDir);

    if (appSettings == null)
        throw new ApplicationException("Missing or invalid config file (appsettings.json)");

    Initialize(appSettings);
    Start();
}
catch (Exception ex)
{
	Log.Error(context, ex, "Unexpected error while executing app - application will now shut down.");
}
finally
{
    Finish();
}

void Start()
{
    var parsers = new List<IBankStatementParser>
    {
        new TatraBankaStatementParser(appSettings),
        new SlovenskaPostaStatementParser(appSettings),
        new VubStatementParser(appSettings),
    };

    var error = false;
    var payments = new List<IPayment>();
    var sources = new List<string>();

    foreach (var parser in parsers)
    {
        error = !parser.TryParseAndConvertPaymentsFromSource(out var outSourceFiles, out var outPayments) || error;
        
        if (outPayments != null)
            payments.AddRange(outPayments);
        
        if (outSourceFiles != null)
            sources.AddRange(outSourceFiles);
    }

    Log.Raw();
    Log.Raw($"Source files used:\n- {string.Join($"{Environment.NewLine}- ", sources)}");

    Log.Raw();
    SerializePaymentsToCsv(payments, GetMergedOutputFileName(payments));
    SerializePaymentsToSql(payments);

    ExtractEmailAttachments();

    Log.Raw();
    Log.Raw($"Completed. Error: {error}");
}

void ExtractEmailAttachments()
{
    if (appSettings.EmailsToExtractDirectory == null)
        throw new ArgumentNullException(appSettings.EmailsToExtractDirectory);

    var sourceDir = Path.Combine(appSettings.EmailsToExtractDirectory);
    if (!Directory.Exists(sourceDir))
        Directory.CreateDirectory(sourceDir);

    var outDir = Path.Combine(appSettings.OutputDirectory, "ExtractedEmailAttachments");
    if (!Directory.Exists(outDir))
        Directory.CreateDirectory(outDir);

    if (appSettings.TestRunMode)
        return;

    var emails = Directory.EnumerateFiles(sourceDir, "*.msg").ToArray();

    if (!emails.Any())
        return;

    Log.Info(context, $"Extracting attachments from {emails.Length} emails in {sourceDir}...");

    foreach (var email in emails)
    {
        Log.Info(context, $"Extracting attachments from {Path.GetFileName(email)}...");
        var attachments = OutlookMailAttachmentsExtractor.ExtractAttachments(email, outDir);
        Log.Info(context, $"Extracted {attachments?.Length} attachments from {Path.GetFileName(email)}.");
    }

    Log.Info(context, $"Extracted all attachments from {emails.Length} emails in {sourceDir}.");
}

void SerializePaymentsToCsv(IEnumerable<IPayment> payments, string outputFile)
{
    if (!payments.Any())
        return;

    // csv export
    Log.Info(context, $"Serialzing payments to {outputFile}");
    var csvRows = payments
        .Select(PaymentFieldsToCsv)
        .ToArray();

    File.WriteAllText(outputFile, $"{appSettings.OutputPaymentsCsvFields}{Environment.NewLine}", Encoding.UTF8);
    File.AppendAllLines(outputFile, csvRows, Encoding.UTF8);
}

void SerializePaymentsToSql(IEnumerable<IPayment> payments)
{
    if (!payments.Any())
        return;

    var paymentsChunks = payments
        .OrderBy(p => p.DateProcessed)
        .GroupBy(p => $"{p.DateProcessed.Year}-Q{(p.DateProcessed.Month + 2) / 3}");

    foreach (var group in paymentsChunks)
    {
        var paymentsChunk = group.ToArray();
        var outputFile = GetMergedOutputFileName(paymentsChunk);

        // sql export
        outputFile = Path.Combine(Path.GetDirectoryName(outputFile), $"{Path.GetFileNameWithoutExtension(outputFile)}.sql");
        Log.Info(context, $"Serialzing payments to {outputFile}");
        var sqlRows = paymentsChunk
            .Select(PaymentFieldsToSql)
            .ToArray();
        var mergedRows = string.Join(",\n\n", sqlRows);
        var createStmt = PaymentsSqlTableCreateScript;
        File.WriteAllText(outputFile, createStmt, Encoding.UTF8);
        File.AppendAllText(outputFile, mergedRows, Encoding.UTF8);
    }
}

string PaymentFieldsToSql(IPayment payment)
{
    try
    {
        int.TryParse(payment.VariableSymbol, out var vs);
        var line = new[] {
            "default",
            $"{payment.Index}", 
            $"'{payment.DateProcessed:yyyy-MM-dd}'", 
            $"{payment.IsCredit}",
            $"{payment.Amount.ToString("#.00", System.Globalization.CultureInfo.InvariantCulture)}",
            $"{vs}",
            $"'{payment.Origin?.Replace('\'', '`')}'",
            $"'{payment.PayerIban}'",
            $"'{payment.PayerName?.Replace('\'', '`')}'",
            $"'{payment.Detail?.Replace('\'', '`')}'",
            $"'{payment.PaymentId}'",
            $"'{payment.BankReference}'",
            $"'{payment.PayerReference}'",
            $"'{payment.Source?.Replace('\'', '`')}'",
        };

        var values = line.Select(s => $"{(s == "''" ? "null" : s)}");
        var row = string.Join(',', values);
        return $"({row})";
    }
    catch (Exception ex)
    {
        Log.Error(context, ex, $"Error while serializing payment to sql: {payment}.");
        throw;
    }   
}

string PaymentFieldsToCsv(IPayment payment)
{
    var fields = appSettings.OutputPaymentsCsvFields.Split(';');
    var values = new List<object>();
    foreach (var field in fields)
    {
        var property = typeof(IPayment).GetProperty(field);
        var value = property.GetValue(payment);
        var stringValue = property.PropertyType switch
        {
            var t when t == typeof(decimal) => ((decimal)value).ToString("#.00"),
            var t when t == typeof(DateTime) => ((DateTime)value).ToString("yyyy-MM-dd"),
            _ => $"{value}",
        };

        values.Add($"\"{stringValue}\"");
    }
    var row = string.Join(';', values);
    return row;
}

string GetMergedOutputFileName(IEnumerable<IPayment> payments)
{
    if (!payments.Any())
        return default;

    var dateFrom = payments.Min(p => p.DateProcessed);
    var dateTo = payments.Max(p => p.DateProcessed);
    var csvFile = $"merged_payments_all_{dateFrom:yyyyMMdd}_{dateTo:yyyyMMdd}_x{payments.Count()}";
    return Path.Combine(appSettings.OutputDirectory, $"{csvFile}.csv");
}

void Finish()
{
    Log.Raw("-----------------------");
    Log.Raw("Shutting down...");
    Log.Raw("-----------------------");

    Log.Raw();
    Log.Raw(new string('*', 20) + " Press any key to exit " + new string('*', 20));
    Console.ReadKey();
}

string? GetCurrentPath()
{
    var result = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
    Log.Info(context, $"Current path: {result}");
    return result;
}

string GetWorkingDirectory()
{
    return Path.Combine("c:", "YellowNET");
}

string GetConfigPath()
{
    return Path.Combine(GetWorkingDirectory(), "appsettings.json");
}

AppSettings? CreateAndReadConfigFile(JsonSerializerOptions jsonOptions, string configPath, string appPath)
{
    Log.Info(context, $"Checking config file {configPath}...");
    if (!File.Exists(configPath))
    {
        File.Copy(Path.Combine(appPath, "appsettings.json"), configPath);
        Log.Info(context, $"Creating new config file {configPath}...");
    }

    Log.Info(context, "Reading config file...");
    
    var result = JsonSerializer.Deserialize<AppSettings>(File.ReadAllText(configPath), jsonOptions);
    
    Log.Info(context, $"Using config:\n{JsonSerializer.Serialize(result, jsonOptions)}");
    
    return result;
}

void Initialize(AppSettings? appSettings)
{
    Log.DebugMode = appSettings.DebugMode;
    PdfUtils.DebugMode = appSettings.DebugMode;
    ZipUtils.DebugMode = appSettings.DebugMode;

    if (appSettings.TestRunMode)
    {
        Log.Info(context, "*** TEST RUN MODE enabled ***");
        Log.Info(context, "- only default folder structure and config file will be created and validated.");
        Log.Info(context, $"- turn this feature off in the config file at {GetConfigPath()}");
    }

    ValidateMainConfig(appSettings);

    if (!Directory.Exists(appSettings.OutputDirectory))
        Directory.CreateDirectory(appSettings.OutputDirectory);
}

void ValidateMainConfig(AppSettings appSettings)
{
    if (appSettings.OutputDirectory == null)
        throw new ArgumentNullException(nameof(appSettings.OutputDirectory));

    if (appSettings.OutputPaymentsCsvFields == null)
        throw new ArgumentNullException(nameof(appSettings.OutputPaymentsCsvFields));

    if (!appSettings.OutputPaymentsCsvFields.Contains(';'))
        throw new ArgumentException("Parameter must contain a semicolon (;) delimited list of fields.", nameof(appSettings.OutputPaymentsCsvFields));

    var properties = typeof(IPayment).GetProperties().Select(p => p.Name);
    var fields = appSettings.OutputPaymentsCsvFields.Split(';');
    if (fields.Any(f => !properties.Contains(f)))
        throw new ArgumentException($"Invalid field in parameter. Supported fields: {string.Join(';', properties)}");

}