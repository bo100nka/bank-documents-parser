using bank_documents_parser;

namespace bank_documents_parser_tests
{
    public class TatraBankaStatementParserTests : IDisposable
    {
        private readonly string TempDir = Directory.CreateTempSubdirectory($"{nameof(TatraBankaStatementParser)}_").FullName;
        private readonly string ParserTestDataPath = Path.GetFullPath("../../../TestData/TatraBanka");
        private readonly string[] TestDataFiles;
        private readonly string[] TempDataFiles;

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
        public void Ctor_WithAPath_ValidatesDirectory()
        {
            Assert.Throws<ArgumentNullException>(
                () => new TatraBankaStatementParser(directory: null));

            Assert.Throws<ApplicationException>(
                () => new TatraBankaStatementParser(directory: "c:/invalid-folder"));

            var parser = new TatraBankaStatementParser(TempDir);

            Assert.NotNull(parser);
        }

        [Fact]
        public void GetFiles_ReturnsListOfFilesMatchingFilePattern()
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
        public void TryParse_ValidatesArguments()
        {
            // Arrange
            var parser = GivenParser();
            var files = parser.GetBankStatementsFiles();
            using var file = new FileStream(files[0], FileMode.Open, FileAccess.Read);

            // Act
            var actual = parser.TryParse(file);

            // Assert
            Assert.NotNull(actual);
        }

        IBankStatementParser GivenParser() => new TatraBankaStatementParser(TempDir);
    }
}