using bank_documents_parser;
using System.Globalization;
using System.Xml.Serialization;

namespace bank_documents_parser_tests
{
    public class VubStatementParserTests : IDisposable
    {
        private readonly string TempDir = Directory.CreateTempSubdirectory($"{nameof(VubStatementParser)}_").FullName;
        private readonly string OutputDir = Directory.CreateTempSubdirectory($"{nameof(VubStatementParser)}_output_").FullName;
        private readonly string ParserTestDataPath = Path.GetFullPath("../../../TestData/VUB");
        private readonly string[] TestDataFiles;
        private readonly string[] TempDataFiles;

        public VubStatementParserTests()
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
            Directory.Delete(OutputDir, true);
        }

        [Theory]
        [InlineData(null, null)]
        [InlineData("c:/invalid", null)]
        [InlineData(null, "test")]
        public void Ctor_ValidatesConfig(string source, string filePattern)
        {
            Assert.Throws<ArgumentNullException>(() => new VubStatementParser(appSettings: default));
            var appSettings = new AppSettings
            {
                VubDirectory = source,
                VubStatementsFilePattern = filePattern,
            };
            Assert.Throws<ArgumentNullException>(() => new VubStatementParser(appSettings));
        }

        [Fact]
        public void GetBankStatementsFiles_ReturnsListOfFilesMatchingFilePattern()
        {
            // Arrange
            //export_SK0702000000002278166653_01-02-2023-01-02-2023.XML
            var parser = GivenParser();

            // Act
            var actual = parser.GetBankStatementsFiles();

            // Assert
            Assert.NotNull(actual);
            Assert.NotEmpty(actual);
            Assert.Single(actual);

            var file1 = actual[0];

            Assert.Equal(Path.GetFileName(TestDataFiles[1]), Path.GetFileName(file1));
        }

        [Fact]
        public void TryParsePayments_ChecksArguments()
        {
            var parser = GivenParser();

            Assert.Throws<ArgumentNullException>(() => parser.TryParsePayments(null, out _));
        }

        [Fact]
        public void TryParsePaymentsFromFile_ExtractsPaymentsFromFile()
        {
            // Arrange
            var parser = GivenParser();
            var files = parser.GetBankStatementsFiles();
            Assert.NotEmpty(files);
            var file = files[0];

            // Act
            var actualCheck = parser.TryParsePaymentsFromFile(file, out var actual);

            // Assert
            Assert.True(actualCheck);
            Assert.NotEmpty(actual);
            Assert.Equal(10, actual[0].Amount);
            Assert.Equal("Kristina Burianova", actual[0].PayerName);
        }

        VubStatementParser GivenParser() => new VubStatementParser(new AppSettings 
        {
            TestRunMode = false,
            DebugMode = false,
            VubDirectory = TempDir, 
            VubStatementsFilePattern = "export_*-*-*-*-*-*.xml",
            OutputDirectory = OutputDir,
        });
    }
}