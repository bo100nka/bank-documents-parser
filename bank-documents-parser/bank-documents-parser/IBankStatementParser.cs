namespace bank_documents_parser
{
    public interface IBankStatementParser
    {
        string[] GetBankStatementsFiles();
        ParseResult TryParse(Stream stream);
    }
}