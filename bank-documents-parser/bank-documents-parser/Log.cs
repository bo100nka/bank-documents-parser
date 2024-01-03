﻿namespace bank_documents_parser
{
    internal static class Log
    {
        internal static bool DebugMode { get; set; }

        internal static void Info(object context, string message)
        {
            AppendLog("INFO", context, message);
        }

        internal static void Error(object context, Exception exception)
        {
            AppendLog("ERROR", context, exception.ToString());
        }

        internal static void Error(object context, Exception exception, string message)
        {
            var stack = DebugMode ? $"\n{exception.StackTrace}" : default;
            AppendLog($"ERROR", context, $"{exception} - {message}{stack}");
        }

        private static string FormatMessage(string logLevel, object context, string message)
        {
            return $"{logLevel}:\t{DateTime.Now:o}\t{context}\t{message}";
        }

        private static void AppendLog(string logLevel, object context, string message)
        {
            var formattedMessage = FormatMessage(logLevel, context, message);
            
            Console.WriteLine(formattedMessage);
            File.AppendAllText("./app.log", $"{formattedMessage}{Environment.NewLine}");
        }
    }
}
