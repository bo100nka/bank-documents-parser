using iTextSharp.text.pdf.parser;
using System.Text;

namespace bank_documents_parser
{
    public static class PdfUtils
    {
        public static bool DebugMode = false;
        private static readonly object context = nameof(PdfUtils);
        public static string? Parse(string file, string? password)
        {
            try
            {
                var result = default(string?);
                Log.Debug(context, $"Extracting text from PDF {file}...");

                var pageText = new StringBuilder();
                var passwordBytes = Encoding.ASCII.GetBytes(password);
                using (var reader = new iTextSharp.text.pdf.PdfReader(file, passwordBytes))
                {
                    var pageNumbers = reader.NumberOfPages;
                    Log.Debug(context, $"Opened PDF {file} with {pageNumbers} pages.");

                    var resultsPerPage = new List<string>();
                    for (int i = 1; i <= pageNumbers; i++)
                    {
                        var text = PdfTextExtractor.GetTextFromPage(reader, i).Replace("\n", "\r\n");
                        Log.Debug(context, $"Extracting text from page {i} of {pageNumbers}...");
                        resultsPerPage.Add(text);
                    }

                    Log.Debug(context, $"Merging text from multiple pages...");
                    result = string.Join("\r\n", resultsPerPage);

                    Log.Debug(context, $"Closing PDF {file}...");
                }

                return result;
            }
            catch (Exception ex)
            {
                Log.Error(context, ex);
            }
            finally
            {
                Log.Debug(context, $"Finished parsing text from PDF {file}.");
            }

            return default;
        }
    }
}
