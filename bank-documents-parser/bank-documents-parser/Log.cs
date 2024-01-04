namespace bank_documents_parser
{
    internal static class Log
    {
        private static readonly string LogPath = Path.Combine("c:", "YellowNET", "app.log");

        internal static bool DebugMode { get; set; } = true;

        internal static void Raw(string message = "")
        {
            AppendLog(default, default, message);
        }

        internal static void Info(object context, string message)
        {
            AppendLog("INFO", context, message);
        }

        internal static void Error(object context, Exception exception)
        {
            AppendLog("ERROR", context, $"{exception.GetType().FullName} - {exception.Message}");
        }

        internal static void Error(object context, Exception exception, string message)
        {
            message = $"{exception.GetType().FullName} - {exception.Message}";
            message = DebugMode ? $"{message}\n{exception.StackTrace}" : message;
            AppendLog($"ERROR", context, message);
        }

        private static string FormatMessage(string logLevel, object context, string message)
        {
            if (logLevel == null)
                return new string(message);

            return $"{logLevel}\t{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}\t{context}\t{message}";
        }

        private static void AppendLog(string logLevel, object context, string message)
        {
            var formattedMessage = FormatMessage(logLevel, context, message);
            
            Console.WriteLine(formattedMessage);
            File.AppendAllText(LogPath, $"{formattedMessage}{Environment.NewLine}");
        }
    }
}
