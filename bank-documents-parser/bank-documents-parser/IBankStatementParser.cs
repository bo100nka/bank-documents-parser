namespace bank_documents_parser
{
    public interface IBankStatementParser
    {
        bool TryParseAndConvertPaymentsFromSource(out string[] outSourceFiles, out IPayment[] outPayments);
    }
}