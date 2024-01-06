using bank_documents_parser;
using System.Text.RegularExpressions;

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

        [Fact]
        public void Ctor_ValidatesConfig()
        {
            Assert.Throws<ArgumentNullException>(
                () => new SlovenskaPostaStatementParser(appSettings: default));

            Assert.Throws<ArgumentNullException>(
                () => new SlovenskaPostaStatementParser(new AppSettings { }));

            Assert.Throws<ArgumentNullException>(
                () => new SlovenskaPostaStatementParser(new AppSettings { SlovenskaPostaStatementsFilePattern = "*.356" }));

            Assert.Throws<ArgumentNullException>(
                () => new SlovenskaPostaStatementParser(new AppSettings { SlovenskaPostaDirectory = "c:/some-folder" }));

            var parser = new SlovenskaPostaStatementParser(new AppSettings 
            {
                OutputDirectory = TempDir,
                SlovenskaPostaDirectory = TempDir, 
                SlovenskaPostaStatementsFilePattern = "*.pdf",
            });

            Assert.NotNull(parser);
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
            Assert.Equal(2, actual.Length);

            var file1 = actual[0];
            var file2 = actual[1];

            Assert.Equal(Path.GetFileName(TestDataFiles[0]), Path.GetFileName(file1));
            Assert.Equal(Path.GetFileName(TestDataFiles[2]), Path.GetFileName(file2));
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
            Assert.Equal(2, actual.Length);

            var actual1 = actual[0];
            Assert.Equal(Path.GetFileName(TempDataFiles[0]).Replace("sk1", "st1"), Path.GetFileName(actual1));

            var actual2 = actual[1];
            Assert.Equal(Path.GetFileName(TempDataFiles[2]).Replace("sk1", "st1"), Path.GetFileName(actual2));

        }

        SlovenskaPostaStatementParser GivenParser() => new SlovenskaPostaStatementParser(new AppSettings 
        {
            TestRunMode = false,
            DebugMode = false,
            SlovenskaPostaDirectory = TempDir, 
            SlovenskaPostaZipPassword = Password,
            SlovenskaPostaStatementsFilePattern = "*.356",
            OutputDirectory = OutputDir,
        });
    }
}