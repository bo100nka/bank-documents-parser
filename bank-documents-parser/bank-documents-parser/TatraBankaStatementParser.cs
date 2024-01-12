using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace bank_documents_parser
{
    public class TatraBankaStatementParser : IBankStatementParser
    {
        private readonly object context = nameof(TatraBankaStatementParser);
        private readonly bool DebugMode;
        private readonly CultureInfo ParseCulture = CultureInfo.InvariantCulture;
        private readonly bool TestRunMode;
        private readonly string Source;
        private readonly string Output;
        private readonly string CsvHeader;
        private readonly string? Password;
        private readonly string SearchPattern;
        public const string SymbolsPattern = @"/VS/*(?<vs>\d*).*";
        public const string CleanupPattern = @"(^------*\r\n)|(^.*popis.*\r\n)|(^Mena .*\r\n)|(^.* Maji.*\r\n)";
        public const string RowPattern_Payment =
              @"(?<date_process>\d{2}\.\d{2}\.\d{4})\s(?<type>platba|tpp|\S)+\s(?<account>\S*)( (?<date_invoice>\d{2}\.\d{2}\.\d{4}))? (?<amount>[,\d]*.\d{2})
(platba trva|prijat).*: (?<payment_id>.*)(
referencia banky.*: (?<bank_reference>.*))?(
referencia platite.*: (?<payer_reference>.*))?(
suma.*)?
banka.*:(?<payer_bank>.*)
platite.*: (?<payer_iban>.*)
(?<payer_name>[^\r\n]*)(
detail: (?<detail>[^\r\n]*))?";

        private readonly Dictionary<char, char> CharsToReplaceLookup = new Dictionary<char, char>()
        {
            ['\u008a'] = 'Š',
            ['\u009a'] = 'š',
            ['\u008e'] = 'Ž',
            ['\u009e'] = 'ž',
            ['ï'] = 'ď',
            ['è'] = 'č',
            ['È'] = 'Č',
            ['¾'] = 'ľ',
            ['¼'] = 'Ľ',
            ['ø'] = 'ř',
            ['\u009d'] = 'ť',
            ['ò'] = 'ň',
        };

        public string CorrectDiacritic(string input)
        {
            var correctedText = input;
            CharsToReplaceLookup.ToList().ForEach(kvp => correctedText = correctedText.Replace(kvp.Key, kvp.Value));
            return correctedText;
        }

        public TatraBankaStatementParser(AppSettings appSettings)
        {
            if (appSettings == null)
                throw new ArgumentNullException(nameof(appSettings));

            TestRunMode = appSettings.TestRunMode;
            DebugMode = appSettings.DebugMode;
            if (appSettings.TestRunMode)
            {
                Log.Info(context, "*** TestRunMode enabled - only config validation and folder structure will be initialized");
            }

            Source = appSettings.TatraBankaDirectory ?? throw new ArgumentNullException(nameof(appSettings.TatraBankaDirectory));
            Output = Path.Combine(appSettings.OutputDirectory ?? throw new ArgumentNullException(nameof(appSettings.OutputDirectory)), "TatraBanka");
            CsvHeader = appSettings.OutputPaymentsCsvFields;
            Password = appSettings.TatraBankaPdfPassword;
            SearchPattern = appSettings.TatraBankaStatementsFilePattern ?? throw new ArgumentNullException(nameof(appSettings.TatraBankaStatementsFilePattern));
            Log.Info(context, $"Starting with folder {appSettings.TatraBankaDirectory}{(appSettings.TatraBankaPdfPassword == null ? null : " and password")}");

            if (!Directory.Exists(Source))
                Directory.CreateDirectory(Source);

            if (!Directory.Exists(Output))
                Directory.CreateDirectory(Output);
        }

        public string[] GetBankStatementsFiles()
        {
            Log.Info(context, $"Getting bank statements from {Source}");

            var result = Directory
                .EnumerateFiles(Source, SearchPattern, SearchOption.TopDirectoryOnly)
                .ToArray();

            Log.Info(context, $"Found {result.Length} bank statements in {Source}");

            return result;
        }

        public bool TryParseRaw(string file, out string result)
        {
            result = default;

            if (string.IsNullOrWhiteSpace(file))
                throw new ArgumentNullException(nameof(file));

            if (!File.Exists(file))
                throw new ApplicationException($"Could not find file {file}");

            try
            {
                Log.Info(context, $"Parsing text from {file}...");
                result = PdfUtils.Parse(file, Password);

                if (result == null)
                    throw new ApplicationException($"Unable to parse PDF {file}.");

                var outputFile = Path.Combine(Output, Path.GetFileName(file).Replace(".pdf", ".parsed.txt"));
                Log.Debug(context, $"Parsed text from {file} ({result?.Length} characters)... Saving to {outputFile}...");
                File.WriteAllText(outputFile, result, Encoding.UTF8);

                Log.Debug(context, $"Performing page break cleanup.");
                var cleaned = Regex.Replace(result, CleanupPattern, string.Empty, RegexOptions.IgnoreCase | RegexOptions.Multiline);
                cleaned = CorrectDiacritic(cleaned);
                outputFile = Path.Combine(Output, Path.GetFileName(file).Replace(".pdf", ".cleaned.txt"));
                Log.Debug(context, $"Cleaned up {file} ({cleaned?.Length} characters)... Saving to {outputFile}...");
                File.WriteAllText(outputFile, cleaned, Encoding.UTF8);
                result = cleaned;
                return true;
            }
            catch (Exception ex)
            {
                Log.Error(context, ex, $"Error while parsing raw text from pdf {file}...");
                return false;
            }   
        }

        public bool TryParsePaymentsFromFile(string text, string origin, out ParseResult result)
        {
            result = default;

            if (text == null)
                throw new ArgumentNullException(nameof(text));

            try
            {
                Log.Info(context, $"Parsing bank statement records from {origin} with {text?.Length} characters...");
                
                var payments = ParsePaymentsFromText(Path.GetFileName(origin), text);
                result = new ParseResult(text, payments.ToArray());
                
                Log.Info(context, $"Parsed {payments?.Count} bank statement records from {origin}.");
                
                return true;
            }
            catch (Exception ex)
            {
                Log.Error(context, ex, $"Error while parsing bank statement records from {origin}.");
                result = new ParseResult(ex);
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
            var pdfs = GetBankStatementsFiles();
            outSourceFiles = pdfs;
            if (!pdfs.Any())
            {
                Log.Info(context, $"No bank statement files found at {Source} - skipping process.");
                return true;
            }

            // parse raw text from found pdf files
            var parsedPdfs = new List<(string file, string rawText)>();
            try
            {
                foreach (var pdf in pdfs)
                {
                    if (!TryParseRaw(pdf, out var parsedPdf))
                        throw new ApplicationException($"Error while parsing raw text from PDF {pdf}");
                    parsedPdfs.Add((pdf, parsedPdf));
                }
            }
            catch (Exception ex)
            {
                Log.Error(context, ex, "Error while parsing raw text from PDFs");
                return false;
            }   

            // parse payments from parsed raw text
            try
            {
                var mergedPayments = new List<IPayment>();
                foreach (var parsedPdf in parsedPdfs)
                {
                    if (!TryParsePaymentsFromFile(parsedPdf.rawText, parsedPdf.file, out var result))
                        throw result.Exception;
                    
                    var outputFile = GetOutputFileName(result.Payments);
                    SerializePayments(result.Payments, outputFile);
                    
                    mergedPayments.AddRange(result.Payments);
                }

                SerializePayments(mergedPayments, GetMergedOutputFileName(mergedPayments));
                outPayments = mergedPayments.ToArray();
                return true;
            }
            catch (Exception ex)
            {
                Log.Error(context, ex, "Error while parsing payments from raw text of PDFs");
                return false;
            }
        }

        private void SerializePayments(IEnumerable<IPayment> payments, string outputFile)
        {
            if (!payments.Any())
                return;

            Log.Debug(context, $"Serialzing payments to {outputFile}");
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

        private string GetOutputFileName(IPayment[]? payments)
        {
            if (!payments.Any())
                return default;

            var csvFile = Path.GetFileNameWithoutExtension(payments.First().Origin);
            return Path.Combine(Output, $"{csvFile}.csv");
        }

        private string GetMergedOutputFileName(IEnumerable<IPayment> payments)
        {
            if (!payments.Any())
                return default;

            var dateFrom = payments.Min(p => p.DateProcessed);
            var dateTo = payments.Max(p => p.DateProcessed);
            var csvFile = $"merged_payments_tb_x{payments.Count()}_{dateFrom:yyyyMMdd}_{dateTo:yyyyMMdd}";
            return Path.Combine(Output, $"{csvFile}.csv");
        }

        private List<IPayment> ParsePaymentsFromText(string? origin, string filteredText)
        {
            var payments = new List<IPayment>();
            var match = Regex.Match(filteredText, RowPattern_Payment, 
                RegexOptions.ExplicitCapture 
                | RegexOptions.IgnoreCase 
                | RegexOptions.Multiline);
            var counter = 0;

            while (match.Success)
            {
                Log.Debug(context, $"Found payment #{++counter}: {match.Groups["date_process"]} - {match.Groups["account"].Value} - {match.Groups["amount"].Value}");

                var index = counter;
                var date_process = DateTime.ParseExact(match.Groups["date_process"].Value, "dd.MM.yyyy", System.Globalization.CultureInfo.CurrentCulture);
                var date_invoice = !match.Groups["date_invoice"].Success ? default(DateTime?) : DateTime.ParseExact(match.Groups["date_invoice"].Value.TrimStart(), "dd.MM.yyyy", System.Globalization.CultureInfo.CurrentCulture);
                var type = match.Groups["type"].Captures.Count > 1 
                    ? string.Join("", match.Groups["type"].Captures.Select(c => c.ToString())) 
                    : match.Groups["type"].Value.ToLowerInvariant();
                var account = match.Groups["account"].Value;
                var amount = decimal.Parse(match.Groups["amount"].Value, ParseCulture);
                var payment_id = match.Groups["payment_id"].Value;
                var bank_reference = match.Groups["bank_reference"].Value;
                var payer_reference = match.Groups["payer_reference"].Value;
                var payer_bank = match.Groups["payer_bank"].Value;
                var payer_iban = match.Groups["payer_iban"].Value;
                var payer_name = match.Groups["payer_name"].Value.Trim();
                var detail = match.Groups["detail"].Value;
                var vs = Regex.Match(payer_reference, SymbolsPattern).Groups["vs"].Value;
                var payment_type =
                    type == "tpp" ? PaymentType.Permanent :
                    type == "platba" ? PaymentType.Manual :
                    string.IsNullOrWhiteSpace(type) ? PaymentType.Unknown : PaymentType.Manual;

                var payment = new Payment
                {
                    Index = index,
                    DateProcessed = date_process,
                    DateInvoiced = date_invoice,
                    PaymentType = payment_type,
                    Account = account,
                    IsCredit = true,
                    Amount = amount,
                    PaymentId = payment_id,
                    BankReference = bank_reference,
                    PayerReference = payer_reference,
                    VariableSymbol = vs,
                    PayerBank = payer_bank,
                    PayerIban = payer_iban,
                    PayerName = payer_name,
                    Detail = detail,
                    Origin = origin,
                    Source = match.Value,
                };

                payments.Add(payment);
                match = match.NextMatch();
            }

            return payments;
        }
    }
}
