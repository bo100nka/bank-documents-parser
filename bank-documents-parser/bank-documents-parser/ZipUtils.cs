using Ionic.Zip;

namespace bank_documents_parser
{
    public static class ZipUtils
    {
        private static readonly object Context = nameof(ZipUtils);
        public static bool DebugMode = false;

        public static bool Decompress(string file, string outFile, string? password = default)
        {
            if (file == null)
                throw new ArgumentNullException(nameof(file));

            try
            {
                if (DebugMode)
                    Log.Info(Context, $"Decompressing {file}...");
                
                using var zip = ZipFile.Read(file);
                zip.Password = password;
                
                zip.ExtractAll(outFile, ExtractExistingFileAction.OverwriteSilently);
                if (DebugMode)
                    Log.Info(Context, $"Decompressed {file}.");
                
                return true;
            }
            catch (Exception ex)
            {
                Log.Error(Context, ex, $"Error while decompressing {file}.");
                return false;
            }
        }
    }
}
