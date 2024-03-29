﻿namespace bank_documents_parser
{
    public class Payment : IPayment
    {
        public int Index { get; set; }

        public DateTime DateProcessed { get; set; }

        public DateTime? DateInvoiced { get; set; }

        public PaymentType PaymentType { get; set; }

        public bool IsCredit { get; set; }

        public string Account { get; set; }

        public decimal Amount { get; set; }

        public string VariableSymbol { get; set; }

        public string SpecificSymbol { get; set; }

        public string Origin { get; set; }
        
        public string PayerReference { get; set; }
        
        public string PayerBank { get; set; }
        
        public string PayerIban { get; set; }
        
        public string PayerName { get; set; }
        
        public string Detail { get; set; }
        
        public string PaymentId { get; set; }
        
        public string BankReference { get; set; }
        
        public string Source { get; set; }

        public override string ToString()
        {
            return $"{DateProcessed} - {Amount} - {PaymentType} - {PayerName} - VS:{VariableSymbol}/SS:{SpecificSymbol} - ID:{PaymentId} - @{Index} - File:{Origin} - {Source}";
        }
    }
}