namespace bank_documents_parser
{
    public class ParseResult
    {
        public ParseResultEnum Result { get; }

        public Exception? Exception { get; } = default;

        public string? RawText { get; }

        public Payment[]? Payments { get; }

        public ParseResult(string rawText, Payment[] payments)
        {
            Result = ParseResultEnum.Success;
            Exception = null;
            RawText = rawText;
            Payments = payments;
        }

        public ParseResult(Exception exception)
        {
            Result = ParseResultEnum.Failure;
            Exception = exception;
            RawText = default;
            Payments = default;
        }
    }
}
