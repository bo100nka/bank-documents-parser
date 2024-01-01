namespace bank_documents_parser
{
    internal static class Log
    {
        internal static bool DebugMode { get; set; }

        internal static void Info(string message)
        {
            Console.WriteLine("INFO:\t" + message);
        }

        internal static void Error(Exception exception)
        {
            Console.WriteLine("ERROR:\t" + exception.ToString());
        }

        internal static void Error(Exception exception, string message)
        {
            var stack = DebugMode ? $"\n{exception.StackTrace}" : default;
            Console.WriteLine($"ERROR:\t + {exception} - {message}{stack}");
        }
    }
}
