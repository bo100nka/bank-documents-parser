using System.Globalization;
using System.IO.Compression;

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
        private readonly string SearchPattern;

        public SlovenskaPostaStatementParser(AppSettings appSettings)
        {
            if (appSettings == null)
                throw new ArgumentNullException(nameof(appSettings));

            TestRunMode = appSettings.TestRunMode;
            if (appSettings.TestRunMode)
            {
                Log.Info(context, "*** TestRunMode enabled - only config validation and folder structure will be initialized");
            }

            Source = appSettings.SlovenskaPostaDirectory ?? throw new ArgumentNullException(nameof(appSettings.SlovenskaPostaDirectory));
            Output = Path.Combine(appSettings.OutputDirectory ?? throw new ArgumentNullException(nameof(appSettings.OutputDirectory)), "SlovenskaPosta");
            CsvHeader = appSettings.OutputPaymentsCsvFields;
            Password = appSettings.SlovenskaPostaZipPassword;
            SearchPattern = appSettings.SlovenskaPostaStatementsFilePattern ?? throw new ArgumentNullException(nameof(appSettings.SlovenskaPostaStatementsFilePattern));
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
                .EnumerateFiles(Source, SearchPattern, SearchOption.TopDirectoryOnly)
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
                    .EnumerateFiles(Output, SearchPattern, SearchOption.TopDirectoryOnly)
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

        public bool TryParseAndConvertPaymentsFromSource()
        {
            throw new NotImplementedException();
        }
    }
}
