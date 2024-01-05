using bank_documents_parser;
using System.Text.RegularExpressions;

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
        public void TryParsePayments_ReturnsCorrectPaymentFromSpecificExample1()
        {
            // Arrange
            var regex = TatraBankaStatementParser.RowPattern_Payment;
            var text = @"
02.11.2023 Platba 1100/000000-2612478602 20.00
Prijatá platba: VP23110253650790
Referencia platiteľa: /VS813042/SS/KS
Suma:20.00EUR Kurz:1.00000000 Valuta:02.11.2023
Banka platiteľa:TATRSKBX
Platiteľ: SK7611000000002612478602
Bučko Martin
Detail: something
";
            
            // Act
            var match = Regex.Match(text, regex, RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase | RegexOptions.Multiline);

            // Assert
            Assert.True(match.Success);
            Assert.Equal("/VS813042/SS/KS", match.Groups["payer_reference"].Value);
            Assert.Equal("02.11.2023", match.Groups["date_process"].Value);
            Assert.Equal("something", match.Groups["detail"].Value);
        }

        [Fact]
        public void test()
        {
            var test = @"
Podnikateľský účet 2942459340 Mena EUR Dátum 30.12.2023
IBAN SK26 1100 0000 0029 4245 9340 BIC (SWIFT) TATRSKBX
---------------------------------------------------------------------------------------------
Číslo klienta: G4B707
Majiteľ účtu: YellowNET, s.r.o.
Robotnícka 58/21
905 01 Senica
SK
Názov účtu: YellowNET, s.r.o.
E-mail: peto@yellownet.sk
084
YellowNET, s.r.o.
Robotnícka 58/21
905 01 Senica
SK
Tatra banka, a.s., Hodžovo nám. 3
811 06 Bratislava
IČO: 00686930
DIČ: 2020408522
Obchodný reg. Mestského súdu Bratislava III,
Oddiel Sa, vložka č. 71/B
POBOČKA/BRANCH 084 SENICA ID: 00 Výpis číslo: 12
---------------------------------------------------------------------------------------------
Vážený klient,
dovoľujeme si Vás informovať o výške zostatku Vášho účtu vedeného v Tatra banke, a.s.
ku koncu kalendárneho roka 2023.
Zároveň Vás prosíme, aby ste nás o prípadných nezrovnalostiach informovali na
adrese: Tatra banka, a.s., Reklamácie, Hodžovo nám. č.3, P.O.BOX 42, 850 05
Bratislava 55, v lehote do 15 dní od doručenia tohto oznámenia.
S úctou
Tatra banka
Zostatok Vášho bežného účtu dňa 31.12.2023 bol:
Číslo účtu Názov účtu Zostatok
---------------------------------------------------------------------------------------------
2942459340 YellowNET, s.r.o. 1,183.50 EUR
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
Mena EUR Výpis číslo: 12 Strana: 1
Podnikateľský účet 2942459340 Majiteľ YellowNET, s.r.o. Dátum 30.12.2023
---------------------------------------------------------------------------------------------
Dátum sprac. Popis Dátum zúčt. Suma
---------------------------------------------------------------------------------------------
Posledný výpis 30.11.2023 333.87
01.12.2023 TPP 1100/000000-2619768418 15.00
Platba trvalým príkazom: VP23120191697073
Suma:15.00EUR Kurz:1.00000000 Valuta:01.12.2023
Banka platiteľa:TATRSKBXXXX
Platiteľ: SK7211000000002619768418
Vícen Juraj, Mgr.
Detail: vicen rovensko
---------------------------------------------------------------------------------------------
01.12.2023 TPP 1100/000000-2910845060 15.00
Platba trvalým príkazom: VP23120191705187
Referencia platiteľa: /VS8011/SS/KS308
Suma:15.00EUR Kurz:1.00000000 Valuta:01.12.2023
Banka platiteľa:TATRSKBXXXX
Platiteľ: SK3911000000002910845060
Vašková Iveta
---------------------------------------------------------------------------------------------
01.12.2023 AP nákup POS 46.01-
Číslo karty: 423473******4117 Držiteľ: ŠUSTER RENÉ
Miesto platby: DOJC CSPHM LMOIL
Dátum: 29.11.23 Čas: 16:30:29 Suma: 46.01- EUR
---------------------------------------------------------------------------------------------
02.12.2023 Platba 0900/000000-0252615482 10.00
Prijatá platba: PO23120266192269
Referencia banky platiteľa: 19885580481-20231202195427.598890
Suma:10.00EUR Kurz:1.00000000 Valuta:02.12.2023
Banka platiteľa:GIBASKBXXXX
Platiteľ: SK2009000000000252615482
Jan Havel
---------------------------------------------------------------------------------------------
02.12.2023 Platba 1100/000000-2934273300 13.30
Prijatá platba: VP23120291865461
Referencia platiteľa: /VS2025/SS/KS
Suma:13.30EUR Kurz:1.00000000 Valuta:02.12.2023
Banka platiteľa:TATRSKBX
Platiteľ: SK7011000000002934273300
Polák Rastislav
Detail: polak rastislav
---------------------------------------------------------------------------------------------
04.12.2023 Platba 1100/000000-2946082827 02.12.2023 200.00
Prijatá platba: VP23120491946904
Suma:200.00EUR Kurz:1.00000000 Valuta:02.12.2023
Banka platiteľa:TATRSKBX
Platiteľ: SK7711000000002946082827
Yellow INTERNET, s.r.o.
---------------------------------------------------------------------------------------------
04.12.2023 Platba 1100/000000-2628005850 02.12.2023 495.65-
Odoslaná platba: VP23120491948183
Referencia platiteľa: /VS0173626417/SS1125848586/KS0308
Suma:495.65EUR Kurz:1.00000000 Valuta:02.12.2023
Banka príjemcu: TATRSKBXXXX
Príjemca: SK2911000000002628005850
ORANGE SLOVENSKO A.S
---------------------------------------------------------------------------------------------
04.12.2023 PLATBA 7500/000000-4025223356 5.00
Prijatá platba: PP23120431102310
Referencia banky platiteľa: 20231203-PRSCT00009536
Referencia platiteľa: /VS0241952654/SS/KS
Suma:5.00EUR Kurz:1.00000000 Valuta:04.12.2023
Banka platiteľa:CEKOSKBX
Platiteľ: SK7875000000004025223356
MACEK ANDREJ
Detail: 14017
---------------------------------------------------------------------------------------------
04.12.2023 PLATBA 1111/000000-1443564002 5.00
Prijatá platba: PP23120430945574
Referencia banky platiteľa: 20231201-IZ612444124
Referencia platiteľa: /VS1121/SS/KS
Suma:5.00EUR Kurz:1.00000000 Valuta:04.12.2023
Banka platiteľa:UNCRSKBXXXX
Platiteľ: SK3811110000001443564002
ROZBORA MIROSLAV
---------------------------------------------------------------------------------------------
04.12.2023 PLATBA 6500/000000-0011849464 10.00
Prijatá platba: PP23120431060994
Referencia banky platiteľa: 10655-20231202-1110639133
Referencia platiteľa: /VS0000010056/SS/KS
Suma:10.00EUR Kurz:1.00000000 Valuta:04.12.2023
Banka platiteľa:POBNSKBA
Platiteľ: SK1265000000000011849464
Machova Maria
---------------------------------------------------------------------------------------------
04.12.2023 PLATBA 0900/000000-0252099772 10.00
Prijatá platba: PP23120431016374
Referencia banky platiteľa: FSY0018758286-20231204
Referencia platiteľa: /VS0000013073/SS/KS0308
---------------------------------------------------------------------------------------------
Mena EUR Výpis číslo: 12 Strana: 2
Podnikateľský účet 2942459340 Majiteľ YellowNET, s.r.o. Dátum 30.12.2023
---------------------------------------------------------------------------------------------
Dátum sprac. Popis Dátum zúčt. Suma
---------------------------------------------------------------------------------------------
Suma:10.00EUR Kurz:1.00000000 Valuta:04.12.2023
Banka platiteľa:GIBASKBX
Platiteľ: SK3409000000000252099772
Roman Drinka";
            var expected = @"
Podnikateľský účet 2942459340 Mena EUR Dátum 30.12.2023
IBAN SK26 1100 0000 0029 4245 9340 BIC (SWIFT) TATRSKBX
Číslo klienta: G4B707
Majiteľ účtu: YellowNET, s.r.o.
Robotnícka 58/21
905 01 Senica
SK
Názov účtu: YellowNET, s.r.o.
E-mail: peto@yellownet.sk
084
YellowNET, s.r.o.
Robotnícka 58/21
905 01 Senica
SK
Tatra banka, a.s., Hodžovo nám. 3
811 06 Bratislava
IČO: 00686930
DIČ: 2020408522
Obchodný reg. Mestského súdu Bratislava III,
Oddiel Sa, vložka č. 71/B
POBOČKA/BRANCH 084 SENICA ID: 00 Výpis číslo: 12
Vážený klient,
dovoľujeme si Vás informovať o výške zostatku Vášho účtu vedeného v Tatra banke, a.s.
ku koncu kalendárneho roka 2023.
Zároveň Vás prosíme, aby ste nás o prípadných nezrovnalostiach informovali na
adrese: Tatra banka, a.s., Reklamácie, Hodžovo nám. č.3, P.O.BOX 42, 850 05
Bratislava 55, v lehote do 15 dní od doručenia tohto oznámenia.
S úctou
Tatra banka
Zostatok Vášho bežného účtu dňa 31.12.2023 bol:
Číslo účtu Názov účtu Zostatok
2942459340 YellowNET, s.r.o. 1,183.50 EUR
Posledný výpis 30.11.2023 333.87
01.12.2023 TPP 1100/000000-2619768418 15.00
Platba trvalým príkazom: VP23120191697073
Suma:15.00EUR Kurz:1.00000000 Valuta:01.12.2023
Banka platiteľa:TATRSKBXXXX
Platiteľ: SK7211000000002619768418
Vícen Juraj, Mgr.
Detail: vicen rovensko
01.12.2023 TPP 1100/000000-2910845060 15.00
Platba trvalým príkazom: VP23120191705187
Referencia platiteľa: /VS8011/SS/KS308
Suma:15.00EUR Kurz:1.00000000 Valuta:01.12.2023
Banka platiteľa:TATRSKBXXXX
Platiteľ: SK3911000000002910845060
Vašková Iveta
01.12.2023 AP nákup POS 46.01-
Číslo karty: 423473******4117 Držiteľ: ŠUSTER RENÉ
Miesto platby: DOJC CSPHM LMOIL
Dátum: 29.11.23 Čas: 16:30:29 Suma: 46.01- EUR
02.12.2023 Platba 0900/000000-0252615482 10.00
Prijatá platba: PO23120266192269
Referencia banky platiteľa: 19885580481-20231202195427.598890
Suma:10.00EUR Kurz:1.00000000 Valuta:02.12.2023
Banka platiteľa:GIBASKBXXXX
Platiteľ: SK2009000000000252615482
Jan Havel
02.12.2023 Platba 1100/000000-2934273300 13.30
Prijatá platba: VP23120291865461
Referencia platiteľa: /VS2025/SS/KS
Suma:13.30EUR Kurz:1.00000000 Valuta:02.12.2023
Banka platiteľa:TATRSKBX
Platiteľ: SK7011000000002934273300
Polák Rastislav
Detail: polak rastislav
04.12.2023 Platba 1100/000000-2946082827 02.12.2023 200.00
Prijatá platba: VP23120491946904
Suma:200.00EUR Kurz:1.00000000 Valuta:02.12.2023
Banka platiteľa:TATRSKBX
Platiteľ: SK7711000000002946082827
Yellow INTERNET, s.r.o.
04.12.2023 Platba 1100/000000-2628005850 02.12.2023 495.65-
Odoslaná platba: VP23120491948183
Referencia platiteľa: /VS0173626417/SS1125848586/KS0308
Suma:495.65EUR Kurz:1.00000000 Valuta:02.12.2023
Banka príjemcu: TATRSKBXXXX
Príjemca: SK2911000000002628005850
ORANGE SLOVENSKO A.S
04.12.2023 PLATBA 7500/000000-4025223356 5.00
Prijatá platba: PP23120431102310
Referencia banky platiteľa: 20231203-PRSCT00009536
Referencia platiteľa: /VS0241952654/SS/KS
Suma:5.00EUR Kurz:1.00000000 Valuta:04.12.2023
Banka platiteľa:CEKOSKBX
Platiteľ: SK7875000000004025223356
MACEK ANDREJ
Detail: 14017
04.12.2023 PLATBA 1111/000000-1443564002 5.00
Prijatá platba: PP23120430945574
Referencia banky platiteľa: 20231201-IZ612444124
Referencia platiteľa: /VS1121/SS/KS
Suma:5.00EUR Kurz:1.00000000 Valuta:04.12.2023
Banka platiteľa:UNCRSKBXXXX
Platiteľ: SK3811110000001443564002
ROZBORA MIROSLAV
04.12.2023 PLATBA 6500/000000-0011849464 10.00
Prijatá platba: PP23120431060994
Referencia banky platiteľa: 10655-20231202-1110639133
Referencia platiteľa: /VS0000010056/SS/KS
Suma:10.00EUR Kurz:1.00000000 Valuta:04.12.2023
Banka platiteľa:POBNSKBA
Platiteľ: SK1265000000000011849464
Machova Maria
04.12.2023 PLATBA 0900/000000-0252099772 10.00
Prijatá platba: PP23120431016374
Referencia banky platiteľa: FSY0018758286-20231204
Referencia platiteľa: /VS0000013073/SS/KS0308
Suma:10.00EUR Kurz:1.00000000 Valuta:04.12.2023
Banka platiteľa:GIBASKBX
Platiteľ: SK3409000000000252099772
Roman Drinka";
            var actual = Regex.Replace(test, TatraBankaStatementParser.CleanupPattern, string.Empty, RegexOptions.IgnoreCase | RegexOptions.Multiline);
            Assert.NotEmpty(actual);
            Assert.Equal(expected, actual);
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
            Assert.True(actualCheck);
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