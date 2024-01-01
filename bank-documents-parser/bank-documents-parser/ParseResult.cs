namespace bank_documents_parser
{
    public class ParseResult
    {
        ParseResultEnum Result { get; }

        Exception? Exception { get; } = default;

        string? RawText { get; }

        Payment[]? Payments { get; }

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
