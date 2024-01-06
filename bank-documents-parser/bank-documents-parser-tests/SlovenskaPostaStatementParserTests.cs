using bank_documents_parser;
using System.Globalization;

namespace bank_documents_parser_tests
{
    public class SlovenskaPostaStatementParserTests : IDisposable
    {
        private readonly string TempDir = Directory.CreateTempSubdirectory($"{nameof(SlovenskaPostaStatementParser)}_").FullName;
        private readonly string OutputDir = Directory.CreateTempSubdirectory($"{nameof(SlovenskaPostaStatementParser)}_output_").FullName;
        private readonly string ParserTestDataPath = Path.GetFullPath("../../../TestData/SlovenskaPosta");
        private readonly string[] TestDataFiles;
        private readonly string[] TempDataFiles;
        private readonly string Password = "023076";

        public SlovenskaPostaStatementParserTests()
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
        [InlineData(null, null, null)]
        [InlineData("c:/invalid", null, null)]
        [InlineData(null, "test", null)]
        [InlineData(null, null, "test")]
        [InlineData("c:/invalid", "test", null)]
        [InlineData("c:/invalid", null, "test")]
        [InlineData(null, "test", "test")]
        public void Ctor_ValidatesConfig(string source, string zipPattern, string textPattern)
        {
            Assert.Throws<ArgumentNullException>(() => new SlovenskaPostaStatementParser(appSettings: default));
            var appSettings = new AppSettings
            {
                SlovenskaPostaDirectory = source,
                SlovenskaPostaStatementsZipFilePattern = zipPattern,
                SlovenskaPostaStatementsTextFilePattern = textPattern,
            };
            Assert.Throws<ArgumentNullException>(() => new SlovenskaPostaStatementParser(appSettings));
        }

        [Fact]
        public void GetBankStatementsFiles_ReturnsListOfFilesMatchingFilePattern()
        {
            // Arrange
            //sk1vztry.356, sk1vztry_iban.356
            var parser = GivenParser();

            // Act
            var actual = parser.GetBankStatementsFiles();

            // Assert
            Assert.NotNull(actual);
            Assert.NotEmpty(actual);
            Assert.Single(actual);

            var file1 = actual[0];

            Assert.Equal(Path.GetFileName(TestDataFiles[2]), Path.GetFileName(file1));
        }

        [Fact]
        public void TryExtractFiles_ChecksArguments()
        {
            // Arrange
            var parser = GivenParser();

            // Act, Assert
            Assert.Throws<ArgumentNullException>(() => parser.TryExtractFiles(files: default, out _));
        }

        [Fact]
        public void TryExtractFiles_ExtractsArchivesToOutputAndReturnsMatchedFiles()
        {
            // Arrange
            var parser = GivenParser();
            var files = parser.GetBankStatementsFiles();

            Assert.NotEmpty(files);
            Assert.Empty(Directory.EnumerateFiles(OutputDir));

            // Act
            var actualCheck = parser.TryExtractFiles(files, out var actual);

            // Assert
            Assert.True(actualCheck);
            Assert.Single(actual);

            var actual2 = actual[0];
            Assert.Equal(Path.GetFileName(TempDataFiles[2]).Replace("sk1", "st1"), Path.GetFileName(actual2));

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
            Assert.True(parser.TryExtractFiles(files, out var extracted));
            Assert.NotEmpty(extracted);
            var file = extracted[0];

            // Act
            var actualCheck = parser.TryParsePaymentsFromFile(file, out var actual);

            // Assert
            Assert.True(actualCheck);
            Assert.NotEmpty(actual);
            Assert.Equal(10, actual[0].Amount);
            Assert.Equal("Katarína Filípková", actual[0].PayerName);
        }

        SlovenskaPostaStatementParser GivenParser() => new SlovenskaPostaStatementParser(new AppSettings 
        {
            TestRunMode = false,
            DebugMode = false,
            SlovenskaPostaDirectory = TempDir, 
            SlovenskaPostaZipPassword = Password,
            SlovenskaPostaStatementsZipFilePattern = "sk1*_iban.*",
            SlovenskaPostaStatementsTextFilePattern = "st1*_iban.*",
            OutputDirectory = OutputDir,
        });
    }
}