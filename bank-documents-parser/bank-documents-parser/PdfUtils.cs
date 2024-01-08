
using Emgu.CV.Text;
using org.apache.pdfbox;
using System.Text;

namespace bank_documents_parser
{
    public static class PdfUtils_temp
    {
        private static readonly object context = nameof(PdfUtils);
        

        
        public static string? Parse(string file, string? password)
        {
            try
            {
                var result = default(string?);
                Log.Info(context, $"Opening PDF {file}...");


                //using (var reader = new iTextSharp.text.pdf.PdfReader(file, passwordBytes))
                //{
                //    var pageNumbers = reader.NumberOfPages;
                //    Log.Info(context, $"Opened PDF {file} with {pageNumbers} pages.");

                //    var resultsPerPage = new List<string>();
                //    for (int i = 1; i <= pageNumbers; i++)
                //    {
                //        var strategy = new SimpleTextExtractionStrategy();
                //        string currentText = PdfTextExtractor.GetTextFromPage(reader, i, strategy);

                //        byte[] pageContent = reader.GetPageContent(i); //not zero based
                //        byte[] utf8 = Encoding.Convert(Encoding.Default, Encoding.UTF8, pageContent);
                //        byte[] unicode = Encoding.Convert(Encoding.Default, Encoding.Unicode, pageContent);
                //        var ansi = Encoding.Convert(Encoding.Default, Encoding.GetEncoding(1250), pageContent);
                //        var latin = Encoding.Convert(Encoding.Default, Encoding.Latin1, pageContent);
                //        string textFromPage = Encoding.UTF8.GetString(utf8);
                //        string textFromPageAnsi = Encoding.GetEncoding(1250).GetString(ansi);
                //        string textFromPageUni = Encoding.Unicode.GetString(unicode);
                //        string textFromPageLatin = Encoding.Latin1.GetString(latin);
                //        currentText = Encoding.UTF8.GetString(Encoding.Convert(Encoding.Default, Encoding.UTF8, Encoding.Default.GetBytes(currentText)));

                        


                //        var text = PdfTextExtractor.GetTextFromPage(reader, i);
                //        pageText.AppendLine(text);
                //        Log.Info(context, $"Extracting text from page {i} of {pageNumbers}...");
                //        resultsPerPage.Add(pageText.ToString());
                //    }

                //    Log.Info(context, $"Merging text from multiple pages...");
                //    result = string.Join("\r\n", resultsPerPage);

                //    Log.Info(context, $"Closing PDF {file}...");
                //}

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
