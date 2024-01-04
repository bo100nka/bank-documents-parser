namespace bank_documents_parser
{
    public interface IBankStatementParser
    {
        string[] GetBankStatementsFiles();
        
        bool TryParseRaw(string file, out string result);
        
        bool TryParsePaymentsFromFile(string text, string origin, out ParseResult result);

        bool TryParseAndConvertPaymentsFromSource();
    }
}