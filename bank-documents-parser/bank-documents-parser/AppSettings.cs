public class AppSettings
{
    public bool DebugMode { get; set; }
    public bool TestRunMode { get; set; }

    public string? TatraBankaPdfPassword { get; set; }
    public string TatraBankaDirectory { get; set; }
    public string TatraBankaStatementsFilePattern { get; set; }

    public string? SlovenskaPostaZipPassword { get; set; }
    public string SlovenskaPostaDirectory { get; set; }
    public string SlovenskaPostaStatementsFilePattern { get; set; }

    public string OutputDirectory { get; set; }
    public string OutputPaymentsCsvFields { get; set; }
}
