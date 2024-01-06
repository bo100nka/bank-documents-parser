namespace bank_documents_parser
{
    public interface IBankStatementParser
    {
        bool TryParseAndConvertPaymentsFromSource();
    }
}