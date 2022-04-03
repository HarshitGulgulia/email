import 'package:email_client/models/Email.dart';
import 'package:enough_mail/enough_mail.dart';

String userName = '1mv20is021@sirmvit.edu';
String password = 'Hg@sirmvit';
String imapServerHost = 'imap.gmail.com';
int imapServerPort = 993;
bool isImapServerSecure = true;

class GetMail{

  List<Email> emails;
  List<MimeMessage> mail_message;

  Future<void> getEmailData() async {
    print("Test1");
    final client = ImapClient(isLogEnabled: true);
    try {
      await client.connectToServer(imapServerHost, imapServerPort,
          isSecure: isImapServerSecure);
      await client.login(userName, password);
      final mailboxes = await client.listMailboxes();
      print('mailboxes: $mailboxes');
      await client.selectInbox();
      // fetch 10 most recent messages:
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 30, criteria: 'BODY.PEEK[]');
      mail_message=fetchResult.messages;
      for (final message in fetchResult.messages) {
        printMessage(message);
      }
    } on ImapException catch (e) {
      print('IMAP failed with $e');
    }
  }

  void printMessage(MimeMessage message) {
    print('from: ${message.from} with subject "${message.decodeSubject()}"');
    if (!message.isTextPlainMessage()) {
      print(' content-type: ${message.mediaType}');
    } else {
      final plainText = message.decodeTextPlainPart();
      if (plainText != null) {
        final lines = plainText.split('\r\n');
        for (final line in lines) {
          if (line.startsWith('>')) {
            // break when quoted text starts
            break;
          }
          print(line);
        }
      }
    }
  }

  Future<String> getEmail() async {
    await getEmail();
    emails=List.generate(
      mail_message.length,
          (index) => Email(
        name: mail_message[index].fromEmail,
        image: "assets/images/user_1.png",
        subject: mail_message[index].decodeSubject(),
        isAttachmentAvailable: false,
        isChecked: true,
        tagColor: null,
        time: mail_message[index].decodeDate().toString(),
        body: mail_message[index].body.toString(),
      ),
    );
    return 'Data Loaded';
  }

}



// List.generate(
//   demo_data.length,
//       (index) => Email(
//     name: demo_data[index]['name'],
//     image: demo_data[index]['image'],
//     subject: demo_data[index]['subject'],
//     isAttachmentAvailable: demo_data[index]['isAttachmentAvailable'],
//     isChecked: demo_data[index]['isChecked'],
//     tagColor: demo_data[index]['tagColor'],
//     time: demo_data[index]['time'],
//     body: emailDemoText,
//   ),
// );