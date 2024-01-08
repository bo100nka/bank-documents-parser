namespace bank_documents_parser
{
    public interface IPayment
    {
        int Index { get; set; }

        DateTime DateProcessed { get; set; }

        decimal Amount { get; set; }

        string VariableSymbol { get; set; }

        public bool IsCredit { get; set; }

        string Origin { get; set; }

        string PayerIban { get; set; }

        string PayerName { get; set; }

        string Detail { get; set; }

        string PaymentId { get; set; }

        string BankReference { get; set; }

        string PayerReference { get; set; }

        string Source { get; set; }
    }
}