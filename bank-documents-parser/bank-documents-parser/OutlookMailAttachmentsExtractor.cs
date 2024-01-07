using MsgReader;
using MsgReader.Outlook;

namespace bank_documents_parser
{
    public static class OutlookMailAttachmentsExtractor
    {
        public static string[] ExtractAttachments(string outlookEmailFile, string outDir)
        {
            var msg = new Storage.Message(outlookEmailFile);
            var attachments = msg.Attachments?.Cast<Storage.Attachment>();

            if (attachments == null)
                return default;

            foreach (var attachment in attachments)
            {
                var outFile = Path.Combine(outDir, attachment.FileName);
                File.WriteAllBytes(outFile, attachment.Data);
            }

            return attachments.Select(x => x.FileName).ToArray();
        }
    }
}
