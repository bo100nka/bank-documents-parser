using UglyToad.PdfPig.Graphics.Operations.SpecialGraphicsState;

namespace bank_documents_parser
{
    public class Payment
    {
        public int Index { get; set; }

        public DateTime DateProcessed { get; set; }

        public DateTime? DateInvoiced { get; set; }

        public PaymentType PaymentType { get; set; }
        
        public string Account { get; set; }

        public decimal Amount { get; set; }

        public string VariableSymbol { get; set; }

        public string Origin { get; set; }
        
        public string ConstantSymbol { get; set; }
        
        public string SpecificSymbol { get; set; }
        
        public string PayerBank { get; set; }
        
        public string PayerIban { get; set; }
        
        public string PayerName { get; set; }
        
        public string Detail { get; set; }
        
        public string PaymentId { get; set; }
        
        public string BankReference { get; set; }

        public override string ToString()
        {
            return $"{DateProcessed} - {Amount} - {PaymentType} - {PayerName} [VS:{VariableSymbol}/KS:{ConstantSymbol}/SS:{SpecificSymbol}] ID:{PaymentId} File:{Origin}] (@{Index})";
        }
    }
}