using System.Xml.Serialization;

namespace bank_documents_parser
{
    [XmlRoot(ElementName = "PstlAdr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class PstlAdr
    {
        [XmlElement(ElementName = "StrtNm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string StrtNm { get; set; }
        [XmlElement(ElementName = "PstCd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string PstCd { get; set; }
        [XmlElement(ElementName = "TwnNm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string TwnNm { get; set; }
        [XmlElement(ElementName = "Ctry", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Ctry { get; set; }
        [XmlElement(ElementName = "BldgNb", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string BldgNb { get; set; }
    }

    [XmlRoot(ElementName = "MsgRcpt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class MsgRcpt
    {
        [XmlElement(ElementName = "Nm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Nm { get; set; }
        [XmlElement(ElementName = "PstlAdr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public PstlAdr PstlAdr { get; set; }
    }

    [XmlRoot(ElementName = "MsgPgntn", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class MsgPgntn
    {
        [XmlElement(ElementName = "PgNb", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string PgNb { get; set; }
        [XmlElement(ElementName = "LastPgInd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string LastPgInd { get; set; }
    }

    [XmlRoot(ElementName = "GrpHdr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class GrpHdr
    {
        [XmlElement(ElementName = "MsgId", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string MsgId { get; set; }
        [XmlElement(ElementName = "CreDtTm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string CreDtTm { get; set; }
        [XmlElement(ElementName = "MsgRcpt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public MsgRcpt MsgRcpt { get; set; }
        [XmlElement(ElementName = "MsgPgntn", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public MsgPgntn MsgPgntn { get; set; }
        [XmlElement(ElementName = "AddtlInf", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string AddtlInf { get; set; }
    }

    [XmlRoot(ElementName = "FrToDt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class FrToDt
    {
        [XmlElement(ElementName = "FrDtTm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string FrDtTm { get; set; }
        [XmlElement(ElementName = "ToDtTm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string ToDtTm { get; set; }
    }

    [XmlRoot(ElementName = "Id", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Id
    {
        [XmlElement(ElementName = "IBAN", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string IBAN { get; set; }
        [XmlElement(ElementName = "OrgId", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public OrgId OrgId { get; set; }
        [XmlElement(ElementName = "Othr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Othr Othr { get; set; }
    }

    [XmlRoot(ElementName = "Tp", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Tp
    {
        [XmlElement(ElementName = "Cd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Cd { get; set; }
        [XmlElement(ElementName = "CdOrPrtry", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public CdOrPrtry CdOrPrtry { get; set; }
    }

    [XmlRoot(ElementName = "Ownr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Ownr
    {
        [XmlElement(ElementName = "PstlAdr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public PstlAdr PstlAdr { get; set; }
    }

    [XmlRoot(ElementName = "FinInstnId", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class FinInstnId
    {
        [XmlElement(ElementName = "BIC", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string BIC { get; set; }
        [XmlElement(ElementName = "Nm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Nm { get; set; }
        [XmlElement(ElementName = "PstlAdr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public PstlAdr PstlAdr { get; set; }
    }

    [XmlRoot(ElementName = "Svcr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Svcr
    {
        [XmlElement(ElementName = "FinInstnId", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public FinInstnId FinInstnId { get; set; }
    }

    [XmlRoot(ElementName = "Acct", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Acct
    {
        [XmlElement(ElementName = "Id", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Id Id { get; set; }
        [XmlElement(ElementName = "Tp", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Tp Tp { get; set; }
        [XmlElement(ElementName = "Ccy", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Ccy { get; set; }
        [XmlElement(ElementName = "Nm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Nm { get; set; }
        [XmlElement(ElementName = "Ownr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Ownr Ownr { get; set; }
        [XmlElement(ElementName = "Svcr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Svcr Svcr { get; set; }
    }

    [XmlRoot(ElementName = "CdOrPrtry", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class CdOrPrtry
    {
        [XmlElement(ElementName = "Cd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Cd { get; set; }
    }

    [XmlRoot(ElementName = "Amt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Amt
    {
        [XmlAttribute(AttributeName = "Ccy")]
        public string Ccy { get; set; }
        [XmlText]
        public string Text { get; set; }
    }

    [XmlRoot(ElementName = "Dt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Dt
    {
        [XmlElement(ElementName = "Dt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public DateTime Date { get; set; }
    }

    [XmlRoot(ElementName = "Bal", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Bal
    {
        [XmlElement(ElementName = "Tp", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Tp Tp { get; set; }
        [XmlElement(ElementName = "Amt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Amt Amt { get; set; }
        [XmlElement(ElementName = "CdtDbtInd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string CdtDbtInd { get; set; }
        [XmlElement(ElementName = "Dt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Dt Dt { get; set; }
    }

    [XmlRoot(ElementName = "TtlNtries", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class TtlNtries
    {
        [XmlElement(ElementName = "NbOfNtries", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string NbOfNtries { get; set; }
        [XmlElement(ElementName = "Sum", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Sum { get; set; }
        [XmlElement(ElementName = "TtlNetNtryAmt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string TtlNetNtryAmt { get; set; }
        [XmlElement(ElementName = "CdtDbtInd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string CdtDbtInd { get; set; }
    }

    [XmlRoot(ElementName = "TtlCdtNtries", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class TtlCdtNtries
    {
        [XmlElement(ElementName = "NbOfNtries", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string NbOfNtries { get; set; }
        [XmlElement(ElementName = "Sum", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Sum { get; set; }
    }

    [XmlRoot(ElementName = "TtlDbtNtries", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class TtlDbtNtries
    {
        [XmlElement(ElementName = "NbOfNtries", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string NbOfNtries { get; set; }
        [XmlElement(ElementName = "Sum", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Sum { get; set; }
    }

    [XmlRoot(ElementName = "TxsSummry", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class TxsSummry
    {
        [XmlElement(ElementName = "TtlNtries", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public TtlNtries TtlNtries { get; set; }
        [XmlElement(ElementName = "TtlCdtNtries", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public TtlCdtNtries TtlCdtNtries { get; set; }
        [XmlElement(ElementName = "TtlDbtNtries", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public TtlDbtNtries TtlDbtNtries { get; set; }
    }

    [XmlRoot(ElementName = "BookgDt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class BookgDt
    {
        [XmlElement(ElementName = "Dt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public DateTime Dt { get; set; }
    }

    [XmlRoot(ElementName = "ValDt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class ValDt
    {
        [XmlElement(ElementName = "Dt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public DateTime Dt { get; set; }
    }

    [XmlRoot(ElementName = "Prtry", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Prtry
    {
        [XmlElement(ElementName = "Cd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Cd { get; set; }
        [XmlElement(ElementName = "Issr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Issr { get; set; }
    }

    [XmlRoot(ElementName = "BkTxCd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class BkTxCd
    {
        [XmlElement(ElementName = "Prtry", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Prtry Prtry { get; set; }
    }

    [XmlRoot(ElementName = "Refs", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Refs
    {
        [XmlElement(ElementName = "InstrId", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string InstrId { get; set; }
        [XmlElement(ElementName = "EndToEndId", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string EndToEndId { get; set; }
    }

    [XmlRoot(ElementName = "InstdAmt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class InstdAmt
    {
        [XmlElement(ElementName = "Amt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Amt Amt { get; set; }
    }

    [XmlRoot(ElementName = "AmtDtls", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class AmtDtls
    {
        [XmlElement(ElementName = "InstdAmt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public InstdAmt InstdAmt { get; set; }
        [XmlElement(ElementName = "CntrValAmt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public CntrValAmt CntrValAmt { get; set; }
    }

    [XmlRoot(ElementName = "OrgId", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class OrgId
    {
        [XmlElement(ElementName = "BICOrBEI", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string BICOrBEI { get; set; }
    }

    [XmlRoot(ElementName = "Dbtr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Dbtr
    {
        [XmlElement(ElementName = "Nm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Nm { get; set; }
        [XmlElement(ElementName = "PstlAdr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public PstlAdr PstlAdr { get; set; }
        [XmlElement(ElementName = "Id", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Id Id { get; set; }
    }

    [XmlRoot(ElementName = "DbtrAcct", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class DbtrAcct
    {
        [XmlElement(ElementName = "Id", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Id Id { get; set; }
    }

    [XmlRoot(ElementName = "Cdtr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Cdtr
    {
        [XmlElement(ElementName = "Nm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Nm { get; set; }
        [XmlElement(ElementName = "PstlAdr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public PstlAdr PstlAdr { get; set; }
        [XmlElement(ElementName = "Id", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Id Id { get; set; }
    }

    [XmlRoot(ElementName = "CdtrAcct", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class CdtrAcct
    {
        [XmlElement(ElementName = "Id", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Id Id { get; set; }
    }

    [XmlRoot(ElementName = "RltdPties", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class RltdPties
    {
        [XmlElement(ElementName = "Dbtr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Dbtr Dbtr { get; set; }
        [XmlElement(ElementName = "DbtrAcct", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public DbtrAcct DbtrAcct { get; set; }
        [XmlElement(ElementName = "Cdtr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Cdtr Cdtr { get; set; }
        [XmlElement(ElementName = "CdtrAcct", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public CdtrAcct CdtrAcct { get; set; }
    }

    [XmlRoot(ElementName = "DbtrAgt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class DbtrAgt
    {
        [XmlElement(ElementName = "FinInstnId", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public FinInstnId FinInstnId { get; set; }
    }

    [XmlRoot(ElementName = "CdtrAgt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class CdtrAgt
    {
        [XmlElement(ElementName = "FinInstnId", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public FinInstnId FinInstnId { get; set; }
    }

    [XmlRoot(ElementName = "RltdAgts", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class RltdAgts
    {
        [XmlElement(ElementName = "DbtrAgt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public DbtrAgt DbtrAgt { get; set; }
        [XmlElement(ElementName = "CdtrAgt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public CdtrAgt CdtrAgt { get; set; }
    }

    [XmlRoot(ElementName = "RmtInf", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class RmtInf
    {
        [XmlElement(ElementName = "Ustrd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Ustrd { get; set; }
    }

    [XmlRoot(ElementName = "TxDtls", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class TxDtls
    {
        [XmlElement(ElementName = "Refs", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Refs Refs { get; set; }
        [XmlElement(ElementName = "AmtDtls", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public AmtDtls AmtDtls { get; set; }
        [XmlElement(ElementName = "RltdPties", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public RltdPties RltdPties { get; set; }
        [XmlElement(ElementName = "RltdAgts", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public RltdAgts RltdAgts { get; set; }
        [XmlElement(ElementName = "RmtInf", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public RmtInf RmtInf { get; set; }
        [XmlElement(ElementName = "AddtlTxInf", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string AddtlTxInf { get; set; }
    }

    [XmlRoot(ElementName = "NtryDtls", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class NtryDtls
    {
        [XmlElement(ElementName = "TxDtls", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public TxDtls TxDtls { get; set; }
    }

    [XmlRoot(ElementName = "Ntry", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Ntry
    {
        [XmlElement(ElementName = "NtryRef", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string NtryRef { get; set; }
        [XmlElement(ElementName = "Amt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Amt Amt { get; set; }
        [XmlElement(ElementName = "CdtDbtInd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string CdtDbtInd { get; set; }
        [XmlElement(ElementName = "RvslInd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string RvslInd { get; set; }
        [XmlElement(ElementName = "Sts", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Sts { get; set; }
        [XmlElement(ElementName = "BookgDt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public BookgDt BookgDt { get; set; }
        [XmlElement(ElementName = "ValDt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public ValDt ValDt { get; set; }
        [XmlElement(ElementName = "BkTxCd", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public BkTxCd BkTxCd { get; set; }
        [XmlElement(ElementName = "NtryDtls", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public NtryDtls NtryDtls { get; set; }
    }

    [XmlRoot(ElementName = "CcyXchg", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class CcyXchg
    {
        [XmlElement(ElementName = "SrcCcy", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string SrcCcy { get; set; }
        [XmlElement(ElementName = "TrgtCcy", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string TrgtCcy { get; set; }
        [XmlElement(ElementName = "XchgRate", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string XchgRate { get; set; }
    }

    [XmlRoot(ElementName = "CntrValAmt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class CntrValAmt
    {
        [XmlElement(ElementName = "Amt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Amt Amt { get; set; }
        [XmlElement(ElementName = "CcyXchg", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public CcyXchg CcyXchg { get; set; }
    }

    [XmlRoot(ElementName = "Othr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Othr
    {
        [XmlElement(ElementName = "Id", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Id { get; set; }
    }

    [XmlRoot(ElementName = "Stmt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class Stmt
    {
        [XmlElement(ElementName = "Id", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string Id { get; set; }
        [XmlElement(ElementName = "LglSeqNb", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string LglSeqNb { get; set; }
        [XmlElement(ElementName = "CreDtTm", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public string CreDtTm { get; set; }
        [XmlElement(ElementName = "FrToDt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public FrToDt FrToDt { get; set; }
        [XmlElement(ElementName = "Acct", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Acct Acct { get; set; }
        [XmlElement(ElementName = "Bal", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public List<Bal> Bal { get; set; }
        [XmlElement(ElementName = "TxsSummry", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public TxsSummry TxsSummry { get; set; }
        [XmlElement(ElementName = "Ntry", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public List<Ntry> Ntry { get; set; }
    }

    [XmlRoot(ElementName = "BkToCstmrStmt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class BkToCstmrStmt
    {
        [XmlElement(ElementName = "GrpHdr", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public GrpHdr GrpHdr { get; set; }
        [XmlElement(ElementName = "Stmt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public Stmt Stmt { get; set; }
    }

    [XmlRoot(ElementName = "Document", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
    public class VubXmlStatement
    {
        [XmlElement(ElementName = "BkToCstmrStmt", Namespace = "urn:iso:std:iso:20022:tech:xsd:camt.053.001.02")]
        public BkToCstmrStmt BkToCstmrStmt { get; set; }
        [XmlAttribute(AttributeName = "xmlns")]
        public string Xmlns { get; set; }
    }
}
