using bank_documents_parser;
using System.Diagnostics;
using System.Reflection;
using System.Text.Json;

var context = "main";

var jsonOptions = new JsonSerializerOptions 
{
	PropertyNameCaseInsensitive = true,
	WriteIndented = true,
	PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    AllowTrailingCommas = true,
    ReadCommentHandling = JsonCommentHandling.Skip,
};

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
    var appSettings = CreateAndReadConfigFile(jsonOptions, configPath, appDir);

    if (appSettings == null)
        throw new ApplicationException("Missing or invalid config file (appsettings.json)");

    Initialize(appSettings);
    Start(appSettings);
}
catch (Exception ex)
{
	Log.Error(context, ex, "Unexpected error while executing app - application will now shut down.");
}
finally
{
    Finish();
}

void Start(AppSettings appSettings)
{
    var parsers = new List<IBankStatementParser>
    {
        new TatraBankaStatementParser(appSettings),
    };

    var error = false;

    foreach (var parser in parsers)
        error = !parser.TryParseAndConvertPaymentsFromSource() || error;

    Log.Info(context, $"Completed. Error: {error}");
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