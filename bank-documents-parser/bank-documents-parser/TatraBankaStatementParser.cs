﻿using System.Text.RegularExpressions;

namespace bank_documents_parser
{
    public class TatraBankaStatementParser : IBankStatementParser
    {
        private readonly string Root;
        private readonly string? Password;
        private readonly string SearchPattern = "*_????-??-??.pdf";

        public TatraBankaStatementParser(string directory, string password)
        {
            Log.Info($"TB: Starting with folder {directory}{(password == null ? null : " and password")}");
            Root = directory ?? throw new ArgumentNullException(nameof(directory));
            Password = password;

            if (!Path.Exists(Root))
                throw new ApplicationException($"Directory {directory} does not exist!");
        }

        public string[] GetBankStatementsFiles()
        {
            Log.Info($"TB: Getting bank statements from {Root}");

            var result = Directory
                .EnumerateFiles(Root, SearchPattern, SearchOption.TopDirectoryOnly)
                .ToArray();

            Log.Info($"TB: Found {result.Length} bank statements in {Root}");

            return result;
        }

        public string TryParseRaw(string file)
        {
            if (string.IsNullOrWhiteSpace(file))
                throw new ArgumentNullException(nameof(file));

            if (!File.Exists(file))
                throw new ApplicationException($"Could not find file {file}");

            Log.Info($"Parsing text from {file}...");
            var result = PdfUtils.Parse(file, Password);
            Log.Info($"Parsed text from {file} ({result?.Length} characters)");

            return result;
        }

        private readonly string RowPattern_Payment =
              @"(?<date_process>\d{2}\.\d{2}\.\d{4})\s(?<type>platba|tpp|\S)+\s(?<account>\S*)( (?<date_invoice>\d{2}\.\d{2}\.\d{4}))? (?<amount>\d*.\d{2})
.*: (?<payment_id>.*)(
.*: (?<bank_reference>.*))?(
.*: /VS(?<vs>\d*)/SS(?<ss>\d*)/KS(?<ks>\d*))?
.*
.*:(?<payer_bank>.*)
.*: (?<payer_iban>.*)
(?<payer_name>.*)(
.*: (?<detail>.*))?";

        public ParseResult TryParsePayments(string text, string? origin = default)
        {
            if (text == null)
                throw new ArgumentNullException(nameof(text));

            try
            {
                var lines = text.Split(Environment.NewLine);
                Log.Info($"Parsing bank statement records from {text?.Length} characters and {lines?.Length} lines...");
                var filteredText = FilterLines(lines);
                var payments = new List<Payment>();
                var match = Regex.Match(filteredText, RowPattern_Payment, RegexOptions.IgnoreCase | RegexOptions.Multiline);

                while (match.Success)
                {
                    var index = match.Index;
                    var date_process = DateTime.ParseExact(match.Groups["date_process"].Value, "dd.MM.yyyy", System.Globalization.CultureInfo.CurrentCulture);
                    var date_invoice = !match.Groups["date_invoice"].Success ? default(DateTime?) : DateTime.ParseExact(match.Groups["date_invoice"].Value.TrimStart(), "dd.MM.yyyy", System.Globalization.CultureInfo.CurrentCulture);
                    var type = match.Groups["type"].Value.ToLowerInvariant();
                    var account = match.Groups["account"].Value;
                    var amount = decimal.Parse(match.Groups["amount"].Value);
                    var payment_id = match.Groups["payment_id"].Value;
                    var bank_reference = match.Groups["bank_reference"].Value;
                    var vs = match.Groups["vs"].Value;
                    var ss = match.Groups["ss"].Value;
                    var ks = match.Groups["ks"].Value;
                    var payer_bank = match.Groups["payer_bank"].Value;
                    var payer_iban = match.Groups["payer_iban"].Value;
                    var payer_name = match.Groups["payer_name"].Value.Trim();
                    var detail = match.Groups["detail"].Value;
                    var payment_type =
                        type == "tpp" ? PaymentType.Permanent :
                        type == "platba" ? PaymentType.Manual : 
                        string.IsNullOrWhiteSpace(type) ? PaymentType.Manual : PaymentType.Unknown;

                    var payment = new Payment
                    {
                        Index = index,
                        DateProcessed = date_process,
                        DateInvoiced = date_invoice,
                        PaymentType = payment_type,
                        Account = account,
                        Amount = amount,
                        PaymentId = payment_id,
                        BankReference = bank_reference,
                        VariableSymbol = vs,
                        SpecificSymbol = ss,
                        ConstantSymbol = ks,
                        PayerBank = payer_bank,
                        PayerIban = payer_iban,
                        PayerName = payer_name,
                        Detail = detail,
                        Origin = origin,
                    };

                    payments.Add(payment);

                    match = match.NextMatch();
                }

                var result = new ParseResult(text, payments.ToArray());
                Log.Info($"Parsed {payments?.Count} bank statement records from {text?.Length} characters.");
                return result;
            }
            catch (Exception ex)
            {
                Log.Error(ex, $"Error while parsing bank statement records from {text?.Length} characters");
                return new ParseResult(ex);
            }
        }

        private static string FilterLines(string[] lines)
        {
            var removeLinesThatContain = new[] {
                "Mena ", 
                " Majite",
                "--------",
                "popis",
            };
            var result = new List<string>(lines.Length);

            foreach (var line in lines)
            {
                var remove = false;
                foreach (var removeLine in removeLinesThatContain)
                    if (line.Contains(removeLine, StringComparison.InvariantCultureIgnoreCase))
                    {
                        remove = true;
                        break;
                    }
                if (!remove)
                    result.Add(line);
            }
            return string.Join(Environment.NewLine, result);
        }
    }
}