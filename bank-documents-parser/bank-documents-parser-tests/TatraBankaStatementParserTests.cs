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

            var parser = new TatraBankaStatementParser(new AppSettings 
            {
                OutputDirectory = TempDir,
                TatraBankaDirectory = TempDir, 
                TatraBankaStatementsFilePattern = "*.pdf",
            });

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
            Assert.Throws<ArgumentNullException>(() => parser.TryParseRaw(default, out _));
            Assert.Throws<ArgumentNullException>(() => parser.TryParseRaw(string.Empty, out _));
            Assert.Throws<ApplicationException>(() => parser.TryParseRaw("c:/not-valid-file.pdf", out _));
        }

        [Fact]
        public void TryParseRaw_ReturnsTextExtractedFromPdfFile()
        {
            // Arrange
            var parser = GivenParser();
            var files = parser.GetBankStatementsFiles();

            // Act
            var actual = parser.TryParseRaw(files[0], out var actualResult);

            // Assert
            Assert.True(actual);
            Assert.NotNull(actualResult);
            Assert.True(actualResult.Length > 1000);
            Assert.StartsWith("Podnikateľský účet 2946082827 Mena EUR Dátum 30.11.2023", actualResult);
            Assert.EndsWith("Mena EUR Výpis číslo: 11 Strana: 32", actualResult);
        }

        [Fact]
        public void TryParsePayments_ValidatesArguments()
        {
            // Arrange
            var parser = GivenParser();

            // Act
            Assert.Throws<ArgumentNullException>(() => parser.TryParsePaymentsFromFile(text: default, origin: "test", out _));
        }

        [Fact]
        public void TryParsePayments_ReturnsPaymentsExtractedFromRawPdfText()
        {
            // Arrange
            var parser = GivenParser();
            var files = parser.GetBankStatementsFiles();
            parser.TryParseRaw(files[0], out var text);

            // Act
            var actualCheck = parser.TryParsePaymentsFromFile(text, Path.GetFileName(files[0]), out var actual);

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
            TestRunMode = false,
            DebugMode = false,
            TatraBankaDirectory = TempDir, 
            TatraBankaPdfPassword = Password,
            TatraBankaStatementsFilePattern = "*_????-??-??.pdf",
            OutputDirectory = TempDir,
        });
    }
}