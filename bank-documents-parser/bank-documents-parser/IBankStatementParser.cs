namespace bank_documents_parser
{
    public interface IBankStatementParser
    {
        string[] GetBankStatementsFiles();
        
        string TryParseRaw(string file);
        
        ParseResult TryParsePayments(string text, string? origin);
    }
}