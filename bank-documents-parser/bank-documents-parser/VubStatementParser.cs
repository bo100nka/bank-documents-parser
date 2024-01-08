using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace bank_documents_parser
{
    public class VubStatementParser : IBankStatementParser
    {
        private readonly object context = nameof(VubStatementParser);
        private readonly bool DebugMode = false;
        private readonly CultureInfo ParseCulture = CultureInfo.InvariantCulture;
        private readonly bool TestRunMode;
        private readonly string Source;
        private readonly string Output;
        private readonly string CsvHeader;
        private readonly string FileSearchPattern;
        private readonly string LineData_Pattern = @"item:
stat_id.*
item_id\s*(?<item_id>\d+)
req_id\s*.*
acn\s*(?<acn>\d*)
date_stat\s*(?<date_process>\d{8})\s*
desc_item\s(?<item>.*)
acn_par.*
bnk_par.*
cd\s*(?<cd>\d*)
amt\s*(?<amount>.*)
var_sym\s*(?<vs>.*)
kon_sym\s*(?<ks>.*)
spec_sym\s*(?<ss>.*)
date_txn\s*.*
amd_value\s*.*
txn_id\s*(?<txn_id>.*)
date_eff\s*(?<date_eff>\d{8})\s*";

        public VubStatementParser(AppSettings appSettings)
        {
            if (appSettings == null)
                throw new ArgumentNullException(nameof(appSettings));

            var provider = CodePagesEncodingProvider.Instance;
            Encoding.RegisterProvider(provider);

            TestRunMode = appSettings.TestRunMode;
            DebugMode = appSettings.DebugMode;
            if (appSettings.TestRunMode)
            {
                Log.Info(context, "*** TestRunMode enabled - only config validation and folder structure will be initialized");
            }

            Source = appSettings.VubDirectory ?? throw new ArgumentNullException(nameof(appSettings.VubDirectory));
            Output = Path.Combine(appSettings.OutputDirectory ?? throw new ArgumentNullException(nameof(appSettings.OutputDirectory)), "Vub");
            CsvHeader = appSettings.OutputPaymentsCsvFields;
            FileSearchPattern = appSettings.VubStatementsFilePattern ?? throw new ArgumentNullException(nameof(appSettings.VubStatementsFilePattern));
            Log.Info(context, $"Starting with folder {appSettings.VubDirectory}");

            if (!Directory.Exists(Source))
                Directory.CreateDirectory(Source);

            if (!Directory.Exists(Output))
                Directory.CreateDirectory(Output);
        }
        
        public string[] GetBankStatementsFiles()
        {
            Log.Info(context, $"Getting bank statements from {Source}");

            var result = Directory
                .EnumerateFiles(Source, FileSearchPattern, SearchOption.TopDirectoryOnly)
                .ToArray();

            Log.Info(context, $"Found {result.Length} bank statements in {Source}");

            return result;
        }

        public bool TryParsePayments(string[] files, out IPayment[]? outPayments)
        {
            if (files == null) 
                throw new ArgumentNullException(nameof(files));

            outPayments = default;
            var payments = new List<IPayment>();

            try
            {
                Log.Info(context, $"Parsing payments from {files.Length} files...");

                foreach (var file in files)
                {
                    Log.Info(context, $"Parsing payments from {file}...");
                    
                    if (!TryParsePaymentsFromFile(file, out var paymentsPerFile))
                        throw new ApplicationException($"Failed to parse payments from {file}.");
                    
                    payments.AddRange(paymentsPerFile);
                    Log.Info(context, $"Parsed {paymentsPerFile.Length} payments from {file}...");
                }

                outPayments = payments.ToArray();
                Log.Info(context, $"Parsed {outPayments.Length} from {files.Length} files.");
                return true;
            }
            catch (Exception ex)
            {
                Log.Error(context, ex, $"Error while parsing payments from {files.Length}");
                return false;
            }
        }

        public bool TryParsePaymentsFromFile(string file, out IPayment[] outPayments)
        {
            if (file == null)
                throw new ArgumentNullException(nameof(file));

            outPayments = default;

            try
            {
                Log.Info(context, $"Parsing payments from {file}...");
                var payments = new List<IPayment>();

                if (DebugMode)
                    Log.Info(context, $"Reading all lines from {file}...");
                var lines = File.ReadAllLines(file, Encoding.GetEncoding(1250));
                if (DebugMode)
                    Log.Info(context, $"Read {lines.Length} line from {file}.");

                if (lines.Length == 1)
                {
                    Log.Info(context, $"File {file} seems to be empty - skipping.");
                    outPayments = Array.Empty<IPayment>();
                    return true;
                }

                if (DebugMode)
                    Log.Info(context, $"Parsing data...");
                var text = string.Join(Environment.NewLine, lines);
                var match = Regex.Match(text, LineData_Pattern, RegexOptions.Multiline | RegexOptions.IgnoreCase);
                if (DebugMode)
                    Log.Info(context, $"Parsed data with {(match.Success ? "Success" : "Failure")} ({match.Captures.Count} payments).");

                while (match.Success)
                {
                    var item_id = int.Parse(match.Groups["item_id"].Value);
                    //Log.Info(context, $"Parsing item {item_id}...");

                    var acn = match.Groups["acn"].Value;
                    var date_process = DateTime.ParseExact(match.Groups["date_process"].Value, "yyyyMMdd", CultureInfo.InvariantCulture);
                    var item = match.Groups["item"].Value;
                    var cd = match.Groups["cd"].Value;
                    var amount_str = match.Groups["amount"].Value;
                    var amount = decimal.Parse(amount_str == "NaN" ? "0" : amount_str, CultureInfo.GetCultureInfo("sk-SK"));
                    var vs = match.Groups["vs"].Value;
                    var ks = match.Groups["ks"].Value;
                    var ss = match.Groups["ss"].Value;
                    var txn_id = match.Groups["txn_id"].Value;
                    var date_eff = DateTime.ParseExact(match.Groups["date_eff"].Value, "yyyyMMdd", CultureInfo.InvariantCulture);
                    var sources = match.Groups
                        .Cast<Group>()
                        .Where(g => g.Name != "0")
                        .Select(g => $"{g.Name}:`{g.Value}`")
                        .ToArray();
                    var source = string.Join(",", sources);
                    var origin = Path.GetFileName(file);

                    var payment = new Payment
                    {
                        Index = item_id,
                        DateProcessed = date_process,
                        DateInvoiced = date_eff,
                        PaymentType = PaymentType.Manual,
                        Account = acn,
                        IsCredit = match.Groups["cd"].Value == "2",
                        Amount = amount,
                        PaymentId = txn_id,
                        BankReference = default,
                        PayerReference = $"/VS{vs}/KS{ks}/SS{ss}",
                        VariableSymbol = vs,
                        PayerBank = default,
                        PayerIban = default,
                        PayerName = default,
                        Detail = item,
                        Origin = origin,
                        Source = source,
                    };

                    payments.Add(payment);
                    match = match.NextMatch();
                }

                outPayments = payments.ToArray();
                Log.Info(context, $"Parsed {outPayments.Length} payments from {file}.");
                return true;
            }
            catch (Exception ex)
            {
                Log.Error(context, ex, $"Error while parsing payments from {file}.");
                return false;
            }
        }

        public bool TryParseAndConvertPaymentsFromSource(out string[] outSourceFiles, out IPayment[] outPayments)
        {
            outPayments = default;
            outSourceFiles = default;
            if (TestRunMode)
            {
                Log.Info(context, "TestRunMode - skipping main process");
                return true;
            }

            // find bank statement files
            var files = GetBankStatementsFiles();
            outSourceFiles = files;
            if (!files.Any())
            {
                Log.Info(context, $"No bank statement files found at {Source} - skipping process.");
                return true;
            }

            // parse payments from found txt files
            try
            {
                var mergedPayments = new List<IPayment>();
                foreach (var file in files)
                {
                    if (!TryParsePaymentsFromFile(file, out var payments))
                        throw new ApplicationException($"Error while parsing payments from {file}.");

                    var outputFile = GetOutputFileName(payments);
                    SerializePayments(payments, outputFile);

                    mergedPayments.AddRange(payments);
                }

                SerializePayments(mergedPayments, GetMergedOutputFileName(mergedPayments));
                outPayments = mergedPayments.ToArray();
                return true;
            }
            catch (Exception ex)
            {
                Log.Error(context, ex, "Error while parsing payments from fixed width files.");
                return false;
            }
        }

        private string GetOutputFileName(IPayment[] payments)
        {
            if (!payments.Any())
                return default;

            var payment = payments.First();
            return Path.Combine(Output, $"{payment.Origin}.csv");
        }

        private void SerializePayments(IEnumerable<IPayment> payments, string outputFile)
        {
            if (!payments.Any())
                return;

            if (DebugMode)
                Log.Info(context, $"Serialzing payments to {outputFile}");
            var csvRows = payments
                .Select(PaymentFieldsToCsv)
                .ToArray();

            File.WriteAllText(outputFile, $"{CsvHeader}{Environment.NewLine}", Encoding.UTF8);
            File.AppendAllLines(outputFile, csvRows, Encoding.UTF8);
        }

        private string PaymentFieldsToCsv(IPayment payment)
        {
            var fields = CsvHeader.Split(';');
            var values = new List<object>();
            foreach (var field in fields)
            {
                var value = typeof(IPayment).GetProperty(field).GetValue(payment);
                values.Add($"\"{value?.ToString()}\"");
            }
            var row = string.Join(';', values);
            return row;
        }

        private string GetMergedOutputFileName(IEnumerable<IPayment> payments)
        {
            if (!payments.Any())
                return default;
            var dateFrom = payments.Min(p => p.DateProcessed);
            var dateTo = payments.Max(p => p.DateProcessed);
            var csvFile = $"merged_payments_vub_x{payments.Count()}_{dateFrom:yyyyMMdd}_{dateTo:yyyyMMdd}";
            return Path.Combine(Output, $"{csvFile}.csv");
        }
    }
}
