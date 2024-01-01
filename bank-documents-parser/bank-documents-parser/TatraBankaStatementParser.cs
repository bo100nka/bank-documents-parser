
using System.IO;

namespace bank_documents_parser
{
    public class TatraBankaStatementParser : IBankStatementParser
    {
        private readonly string Root;
        private readonly string SearchPattern = "*_????-??-??.pdf";

        public TatraBankaStatementParser(string directory)
        {
            Log.Info($"TB: Starting with folder {directory}");
            Root = directory ?? throw new ArgumentNullException(nameof(directory));

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

        public ParseResult TryParse(Stream stream)
        {
            try
            {
                var payments = new List<Payment>()
                {
                    new Payment()
                };

                var result = new ParseResult(string.Empty, payments.ToArray());
                return result;
            }
            catch (Exception ex)
            {
                return new ParseResult(ex);
            }
        }
    }
}
