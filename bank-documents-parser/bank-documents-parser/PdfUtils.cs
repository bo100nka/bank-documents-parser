using UglyToad.PdfPig;
using UglyToad.PdfPig.DocumentLayoutAnalysis.TextExtractor;

namespace bank_documents_parser
{
    public static class PdfUtils
    {
        private static readonly object context = nameof(PdfUtils);
        public static string? Parse(string file, string? password)
        {
            try
            {
                var result = default(string?);
                Log.Info(context, $"Opening PDF {file}...");
                using (var pdf = PdfDocument.Open(file, new ParsingOptions { Password = password }))
                {
                    Log.Info(context, $"PDF opened, found {pdf.NumberOfPages}.");

                    var resultsPerPage = new List<string>();
                    foreach (var page in pdf.GetPages())
                    {
                        Log.Info(context, $"Extracting text from page {page.Number} of {pdf.NumberOfPages}...");
                        resultsPerPage.Add(ContentOrderTextExtractor.GetText(page));
                    }

                    Log.Info(context, $"Merging text from multiple pages...");
                    result = string.Join("\r\n", resultsPerPage);

                    Log.Info(context, $"Closing PDF {file}...");
                }

                return result;
            }
            catch (Exception ex)
            {
                Log.Error(context, ex);
            }
            finally
            {
                Log.Info(context, $"Finished parsing text from PDF {file}.");
            }

            return default;
        }
    }
}
