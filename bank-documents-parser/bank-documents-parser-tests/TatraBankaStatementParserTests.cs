using bank_documents_parser;

namespace bank_documents_parser_tests
{
    public class TatraBankaStatementParserTests : IDisposable
    {
        private readonly string TempDir = Directory.CreateTempSubdirectory($"{nameof(TatraBankaStatementParser)}_").FullName;
        private readonly string ParserTestDataPath = Path.GetFullPath("../../../TestData/TatraBanka");
        private readonly string[] TestDataFiles;
        private readonly string[] TempDataFiles;
        private readonly string Password = "023076netware";

        public TatraBankaStatementParserTests()
        {
            TestDataFiles = Directory.EnumerateFiles(ParserTestDataPath).ToArray();

            foreach (var dataFile in TestDataFiles)
                File.Copy(dataFile, Path.Combine(TempDir, Path.GetFileName(dataFile)), true);

            File.WriteAllText(Path.Combine(TempDir, "test1.txt"), default);
            File.WriteAllText(Path.Combine(TempDir, "test2.pdf"), default);
            File.WriteAllText(Path.Combine(TempDir, "test3.doc"), default);
            File.WriteAllText(Path.Combine(TempDir, "test4.csv"), default);

            TempDataFiles = Directory.EnumerateFiles(TempDir).ToArray();
        }

        public void Dispose()
        {
            Directory.Delete(TempDir, true);
        }

        [Fact]
        public void Ctor_ValidatesConfig()
        {
            Assert.Throws<ArgumentNullException>(
                () => new TatraBankaStatementParser(appSettings: default));

            Assert.Throws<ArgumentNullException>(
                () => new TatraBankaStatementParser(new AppSettings { }));

            Assert.Throws<ArgumentNullException>(
                () => new TatraBankaStatementParser(new AppSettings { TatraBankaStatementsFilePattern = "*.pdf" }));

            Assert.Throws<ArgumentNullException>(
                () => new TatraBankaStatementParser(new AppSettings { TatraBankaDirectory = "c:/some-folder" }));

            Assert.Throws<ApplicationException>(
                () => new TatraBankaStatementParser(new AppSettings { TatraBankaDirectory = "c:/invalid-folder", TatraBankaStatementsFilePattern = "*.pdf" }));

            var parser = new TatraBankaStatementParser(new AppSettings { TatraBankaDirectory = TempDir, TatraBankaStatementsFilePattern = "*.pdf" });

            Assert.NotNull(parser);
        }

        [Fact]
        public void GetBankStatementsFiles_ReturnsListOfFilesMatchingFilePattern()
        {
            // Arrange
            //82827_00_3685_2023-12-01.pdf
            var parser = GivenParser();

            // Act
            var actual = parser.GetBankStatementsFiles();

            // Assert
            Assert.NotNull(actual);
            Assert.NotEmpty(actual);
            Assert.Single(actual);

            var file1 = actual[0];

            Assert.Equal(Path.GetFileName(TestDataFiles[0]), Path.GetFileName(file1));
        }

        [Fact]
        public void TryParseRaw_ValidatesFile()
        {
            // Arrange
            var parser = GivenParser();

            // Act, Assert
            Assert.Throws<ArgumentNullException>(() => parser.TryParseRaw(file: default));
            Assert.Throws<ArgumentNullException>(() => parser.TryParseRaw(file: string.Empty));
            Assert.Throws<ApplicationException>(() => parser.TryParseRaw(file: "c:/not-valid-file.pdf"));
        }

        [Fact]
        public void TryParseRaw_ReturnsTextExtractedFromPdfFile()
        {
            // Arrange
            var parser = GivenParser();
            var files = parser.GetBankStatementsFiles();

            // Act
            var actual = parser.TryParseRaw(files[0]);

            // Assert
            Assert.NotNull(actual);
            Assert.True(actual.Length > 1000);
            Assert.StartsWith("Podnikateľský účet 2946082827 Mena EUR Dátum 30.11.2023", actual);
            Assert.EndsWith("Mena EUR Výpis číslo: 11 Strana: 32", actual);
        }

        [Fact]
        public void TryParsePayments_ValidatesArguments()
        {
            // Arrange
            var parser = GivenParser();

            // Act
            Assert.Throws<ArgumentNullException>(() => parser.TryParsePayments(text: default, origin: "test"));
        }

        [Fact]
        public void TryParsePayments_ReturnsPaymentsExtractedFromRawPdfText()
        {
            // Arrange
            var parser = GivenParser();
            var files = parser.GetBankStatementsFiles();
            var text = parser.TryParseRaw(files[0]);

            // Act
            var actual = parser.TryParsePayments(text, origin: "test");

            // Assert
            Assert.NotNull(actual);
            Assert.Equal(ParseResultEnum.Success, actual.Result);
            Assert.Equal(275, actual.Payments.Length);
            Assert.NotNull(actual.RawText);
            Assert.StartsWith("Podnikateľský účet 2946082827 Mena EUR Dátum 30.11.2023", actual.RawText);
            Assert.EndsWith("Mena EUR Výpis číslo: 11 Strana: 32", actual.RawText);
            Assert.Null(actual.Exception);
        }

        IBankStatementParser GivenParser() => new TatraBankaStatementParser(new AppSettings 
        {
            TatraBankaDirectory = TempDir, 
            TatraBankaPdfPassword = Password,
            TatraBankaStatementsFilePattern = "*_????-??-??.pdf",
        });
    }
}