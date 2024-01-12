using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml.Serialization;

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
        public const string SymbolsPattern = @"/VS/*(?<vs>\d*).*";
        public const string EntryPattern = @" *<Ntry>\n.*<NtryRef>#PAYMENT_ID#</NtryRef>(\n.*?)*?</Ntry>";

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

                Log.Debug(context, $"Reading all text from {file}...");
                var text = File.ReadAllText(file, Encoding.GetEncoding(1250));
                Log.Debug(context, $"Read all text from {file}.");

                Log.Debug(context, $"Parsing data...");
                var record = default(VubXmlStatement);
                {
                    var serializer = new XmlSerializer(typeof(VubXmlStatement));
                    using var reader = new StringReader(text);
                    record = (VubXmlStatement)serializer.Deserialize(reader);
                }
                Log.Debug(context, $"Parsed statement for {record.BkToCstmrStmt.GrpHdr.MsgRcpt.Nm} with ({record.BkToCstmrStmt.Stmt.TxsSummry.TtlNtries.NbOfNtries} credit/debit entries).");

                foreach (var (ntry, index) in record.BkToCstmrStmt.Stmt.Ntry.Select((ntry, index) => (ntry, index)))
                {
                    var paymentId = ntry.NtryRef;
                    var amount = decimal.Parse(ntry.Amt.Text, CultureInfo.InvariantCulture);
                    Log.Debug(context, $"Reading entry {ntry.CdtDbtInd} - {index} - {paymentId} - {amount}...");

                    var isCredit = ntry.CdtDbtInd == "CRDT";
                    var dateBook = ntry.BookgDt?.Dt;
                    var dateVal = ntry.ValDt.Dt;
                    var bankRef = ntry.NtryDtls.TxDtls.Refs.InstrId;
                    var payerRef = ntry.NtryDtls.TxDtls.Refs.EndToEndId;
                    var vs = Regex.Match(payerRef, SymbolsPattern).Groups["vs"].Value;
                    var payerName = ntry.NtryDtls.TxDtls.RltdPties.Dbtr?.Nm;
                    var account = ntry.NtryDtls.TxDtls.RltdPties.DbtrAcct.Id.IBAN;
                    var street = ntry.NtryDtls.TxDtls.RltdPties.Dbtr?.PstlAdr?.StrtNm;
                    var city = ntry.NtryDtls.TxDtls.RltdPties.Dbtr?.PstlAdr?.TwnNm;
                    var country = ntry.NtryDtls.TxDtls.RltdPties.Dbtr?.PstlAdr?.Ctry;
                    var postalCode = ntry.NtryDtls.TxDtls.RltdPties.Dbtr?.PstlAdr?.PstCd;
                    var buildingNumber = ntry.NtryDtls.TxDtls.RltdPties.Dbtr?.PstlAdr?.BldgNb;
                    var detail = ntry.NtryDtls.TxDtls.AddtlTxInf;
                    var paymentCaptured = Regex.Match(text, EntryPattern.Replace("#PAYMENT_ID#", paymentId), RegexOptions.Multiline | RegexOptions.ExplicitCapture);
                    var source = paymentCaptured.Value.Replace("\"", "`");
                    var origin = Path.GetFileName(file);

                    var payment = new Payment
                    {
                        Index = index + 1,
                        DateProcessed = dateVal,
                        DateInvoiced = dateBook,
                        PaymentType = PaymentType.Manual,
                        Account = account,
                        IsCredit = isCredit,
                        Amount = amount,
                        PaymentId = paymentId,
                        BankReference = bankRef,
                        PayerReference = payerRef,
                        VariableSymbol = vs,
                        PayerBank = default,
                        PayerIban = account,
                        PayerName = payerName,
                        Detail = detail,
                        Origin = origin,
                        Source = source,
                    };

                    payments.Add(payment);
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

        private string GetMergedOutputFileName(IEnumerable<IPayment> payments)
        {
            if (!payments.Any())
                return default;
            var dateFrom = payments.Min(p => p.DateProcessed);
            var dateTo = payments.Max(p => p.DateProcessed);
            var csvFile = $"merged_payments_vub_{dateFrom:yyyyMMdd}_{dateTo:yyyyMMdd}_x{payments.Count()}";
            return Path.Combine(Output, $"{csvFile}.csv");
        }
    }
}
