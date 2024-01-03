using UglyToad.PdfPig;
using UglyToad.PdfPig.DocumentLayoutAnalysis.TextExtractor;

namespace bank_documents_parser
{
    public static class PdfUtils
    {
        public static string? Parse(string file, string? password)
        {
            try
            {
                var result = default(string?);
                Log.Info($"Opening PDF {file}...");

                using (var pdf = PdfDocument.Open(file, new ParsingOptions { Password = password }))
                {
                    var resultsPerPage = new List<string>();
                    foreach (var page in pdf.GetPages())
                    {
                        // Either extract based on order in the underlying document with newlines and spaces.
                        var text = ContentOrderTextExtractor.GetText(page);

                        //// Or based on grouping letters into words.
                        //var otherText = string.Join(" ", page.GetWords());

                        //// Or the raw text of the page's content stream.
                        //var rawText = page.Text;

                        resultsPerPage.Add(text);
                    }
                    result = string.Join("\r\n", resultsPerPage);
                }

                return result;
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }

            return default;
        }
    }
}
