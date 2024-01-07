using System;
using System.Globalization;
using System.IO.Compression;
using System.Security.Principal;
using System.Text;
using System.Text.RegularExpressions;

namespace bank_documents_parser
{
    public class SlovenskaPostaStatementParser : IBankStatementParser
    {
        private readonly object context = nameof(SlovenskaPostaStatementParser);
        private readonly CultureInfo ParseCulture = CultureInfo.InvariantCulture;
        private readonly bool TestRunMode;
        private readonly string Source;
        private readonly string Output;
        private readonly string CsvHeader;
        private readonly string? Password;
        private readonly string ZipFileSearchPattern;
        private readonly string TextFileSearchPattern;
        private readonly string LineHeader1_Pattern = @"4(?<date_process>\d{8})(?<date_due>\d{8})(?<org_id>.{5})(?<org_name>.{50})(?<org_ico>.{15})(?<org_dic>.{15})";
        private readonly string LineHeader2_Pattern = @"1(?<date_process>\d{8})(?<date_due>\d{8})(?<org_iban>.{34})(?<end2end_id>.{35})";
        private readonly string LineData_Pattern = @"2(?<product_code>\d{2})(?<service_code>\d{2})(?<rpc>\d{3})(?<postal_code>\d{6})(?<postal_num>\d{5})(?<postal_char>.{1})(?<date_submit>\d{8})(?<amount>\d{12})(?<statement_price>\d{6})(?<statement_payment_type>.{1})(?<amount_payout>\d{6})(?<payout_payment_type>.{1})(?<org_iban>.{34})(?<ks>\d{4})(?<vs>\d{10})(?<ss>\d{10})(?<process_code>\d{1})(?<payer_lname>.{17})(?<payer_fname>.{17})(?<payer_street>.{34})(?<payer_house_number>.{11})(?<payer_postal_code>\d{5})(?<payer_post>.{17})(?<payer_message>.{24})(?<control_num>.{1})";
        private readonly string LineFooter1_Pattern = @"3(?<data_rows>\d{6})(?<data_amount>\d{14})(?<statement_amount>\d{8})(?<payout_amount>\d{8})";
        private readonly string LineFooter2_Pattern = @"5(?<count_files>\d{6})(?<count_data>\d{8})(?<amount_data>\d{14})(?<amount_statement>\d{8})(?<amount_payout>\d{8})";
        public const string SymbolsPattern = @"/VS/*(?<vs>\d*).*";

        public SlovenskaPostaStatementParser(AppSettings appSettings)
        {
            if (appSettings == null)
                throw new ArgumentNullException(nameof(appSettings));

            var provider = CodePagesEncodingProvider.Instance;
            Encoding.RegisterProvider(provider);

            TestRunMode = appSettings.TestRunMode;
            if (appSettings.TestRunMode)
            {
                Log.Info(context, "*** TestRunMode enabled - only config validation and folder structure will be initialized");
            }

            Source = appSettings.SlovenskaPostaDirectory ?? throw new ArgumentNullException(nameof(appSettings.SlovenskaPostaDirectory));
            Output = Path.Combine(appSettings.OutputDirectory ?? throw new ArgumentNullException(nameof(appSettings.OutputDirectory)), "SlovenskaPosta");
            CsvHeader = appSettings.OutputPaymentsCsvFields;
            Password = appSettings.SlovenskaPostaZipPassword;
            ZipFileSearchPattern = appSettings.SlovenskaPostaStatementsZipFilePattern ?? throw new ArgumentNullException(nameof(appSettings.SlovenskaPostaStatementsZipFilePattern));
            TextFileSearchPattern = appSettings.SlovenskaPostaStatementsTextFilePattern ?? throw new ArgumentNullException(nameof(appSettings.SlovenskaPostaStatementsTextFilePattern));
            Log.Info(context, $"Starting with folder {appSettings.SlovenskaPostaDirectory}{(appSettings.SlovenskaPostaZipPassword == null ? null : " and password")}");

            if (!Directory.Exists(Source))
                Directory.CreateDirectory(Source);

            if (!Directory.Exists(Output))
                Directory.CreateDirectory(Output);
        }
        
        public string[] GetBankStatementsFiles()
        {
            Log.Info(context, $"Getting bank statements from {Source}");

            var result = Directory
                .EnumerateFiles(Source, ZipFileSearchPattern, SearchOption.TopDirectoryOnly)
                .ToArray();

            Log.Info(context, $"Found {result.Length} bank statements in {Source}");

            return result;
        }

        public bool TryExtractFiles(string[] files, out string[] outputFiles)
        {
            outputFiles = default;
            if (files == null) throw new ArgumentNullException(nameof(files));

            try
            {
                Log.Info(context, $"Decompressing {files.Length} files to {Output}...");

                foreach (var file in files)
                {
                    if (!ZipUtils.Decompress(file, Output, Password))
                        throw new ApplicationException($"Error while decompressing {file}.");

                    Log.Info(context, "Processing decompressed file...");
                }

                outputFiles = Directory
                    .EnumerateFiles(Output, TextFileSearchPattern, SearchOption.TopDirectoryOnly)
                    .Where(f => Regex.IsMatch(f, @"^.*\.\d{3}$"))
                    .ToArray();

                Log.Info(context, $"Extracted {files.Length} files to {Output}.");
                return true;
            }
            catch (Exception ex)
            {
                Log.Error(context, ex);
                return false;
            }   
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

                Log.Info(context, $"Reading all lines from {file}...");
                var lines = File.ReadAllLines(file, Encoding.GetEncoding(1250));
                Log.Info(context, $"Read {lines.Length} from {file}.");

                Log.Info(context, $"Parsing header row 1...");
                var match_header1 = Regex.Match(lines[0], LineHeader1_Pattern);
                Log.Info(context, $"Parsed header row 1.");

                Log.Info(context, $"Parsing header row 2...");
                var match_header2 = Regex.Match(lines[1], LineHeader2_Pattern);
                Log.Info(context, $"Parsed header row 2.");

                for (int row = 2; row < lines.Length - 2; row++)
                {
                    Log.Info(context, $"Parsing data row {row - 2}...");
                    var match_data = Regex.Match(lines[row], LineData_Pattern);

                    var product_code = match_data.Groups["product_code"].Value;
                    var service_code = match_data.Groups["service_code"].Value;
                    var rpc = match_data.Groups["rpc"].Value;
                    var postal_code = match_data.Groups["postal_code"].Value;
                    var postal_num = match_data.Groups["postal_num"].Value;
                    var postal_char = match_data.Groups["postal_char"].Value;
                    var date_submit = DateTime.ParseExact(match_data.Groups["date_submit"].Value, "ddMMyyyy", CultureInfo.InvariantCulture);
                    var amount = decimal.Parse(match_data.Groups["amount"].Value) / 100;
                    var statement_price = decimal.Parse(match_data.Groups["statement_price"].Value) / 100;
                    var statement_payment_type = match_data.Groups["statement_payment_type"].Value;
                    var amount_payout = decimal.Parse(match_data.Groups["amount_payout"].Value) / 100;
                    var payout_payment_type = match_data.Groups["payout_payment_type"].Value;
                    var ks = match_data.Groups["ks"].Value;
                    var vs = match_data.Groups["vs"].Value;
                    var ss = match_data.Groups["ss"].Value;
                    var process_code = match_data.Groups["process_code"].Value;
                    var payer_fname = match_data.Groups["payer_fname"].Value.Trim();
                    var payer_lname = match_data.Groups["payer_lname"].Value.Trim();
                    var payer_street = match_data.Groups["payer_street"].Value.Trim();
                    var payer_house = match_data.Groups["payer_house_number"].Value.Trim();
                    var payer_postal_code = match_data.Groups["payer_postal_code"].Value;
                    var payer_post = match_data.Groups["payer_post"].Value.Trim();
                    var payer_message = match_data.Groups["payer_message"].Value.Trim();

                    var sources = match_data.Groups
                        .Cast<Group>()
                        .Where(g => g.Index > 0)
                        .Select(g => $"{g.Name}:`{g.Value}`")
                        .ToArray();
                    var source = string.Join(",", sources);
                    var origin = Path.GetFileName(file);

                    var payment = new Payment
                    {
                        Index = row - 2,
                        DateProcessed = date_submit,
                        DateInvoiced = date_submit,
                        PaymentType = PaymentType.Post,
                        Account = default,
                        Amount = amount,
                        PaymentId = default,
                        BankReference = default,
                        PayerReference = $"/VS{vs}/KS{ks}/SS{ss}",
                        VariableSymbol = vs,
                        PayerBank = default,
                        PayerIban = default,
                        PayerName = $"{payer_fname} {payer_lname}",
                        Detail = payer_message,
                        Origin = origin,
                        Source = source,
                    };

                    payments.Add(payment);
                    Log.Info(context, $"Parsed data row {row - 2}.");
                }

                Log.Info(context, $"Parsing footer row 1...");
                var match_footer1 = Regex.Match(lines[lines.Length - 2], LineFooter1_Pattern);
                Log.Info(context, $"Parsed footer row 1.");

                Log.Info(context, $"Parsing footer row 2...");
                var match_footer2 = Regex.Match(lines[lines.Length - 1], LineFooter2_Pattern);
                Log.Info(context, $"Parsed footer row 2.");

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
            var zips = GetBankStatementsFiles();
            outSourceFiles = zips;
            if (!zips.Any())
            {
                Log.Info(context, $"No bank statement files found at {Source} - skipping process.");
                return true;
            }

            // extract found compressed files
            var files = default(string[]);
            try
            {
                if (!TryExtractFiles(zips, out files))
                    throw new ApplicationException($"Error while extracting {zips.Length} files.");
            }
            catch (Exception ex)
            {
                Log.Error(context, ex, "Error while extracting zip files");
                return false;
            }

            // parse payments from extracted fixed width files
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
            var payment = payments.First();
            return Path.Combine(Output, $"{payment.Origin}.csv");
        }

        private void SerializePayments(IEnumerable<IPayment> payments, string outputFile)
        {
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
            var dateFrom = payments.Min(p => p.DateProcessed);
            var dateTo = payments.Max(p => p.DateProcessed);
            var csvFile = $"merged_payments_slposta_x{payments.Count()}_{dateFrom:yyyyMMdd}_{dateTo:yyyyMMdd}";
            return Path.Combine(Output, $"{csvFile}.csv");
        }
    }
}
