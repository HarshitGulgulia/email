import 'package:email_client/models/Email.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';


class GetMail{

  List<Email> emails;
  List<MimeMessage> mail_message;

  String userName = '1mv20is021@sirmvit.edu';
  String password = 'Hg@sirmvit';
  String imapServerHost = 'imap.gmail.com';
  int imapServerPort = 993;
  bool isImapServerSecure = true;

  Future<String> getImapEmail() async {
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
      mail_message = fetchResult.messages;

      for (final message in fetchResult.messages) {
        printMessage(message);
      }

      // for (final message in fetchResult.messages){
      //   print(message.decodeSender().single.personalName);
      //   print(" => flag: "+message.isFlagged.toString());
      //   print("Flags are: ");
      //   print(message.flags);
      // }
      await client.logout();
      return 'Data Loaded';
    } on ImapException catch (e) {
      print('IMAP failed with $e');
      return 'error';
    }
  }



  Future<String> getEmail() async {
    var response = await getImapEmail();
    if (response == 'Data Loaded'){
        emails = List.generate(

          mail_message.length,

              (index) =>
              Email(
                name: mail_message[index].decodeSender().single.personalName,
                image: "assets/images/user_1.png",
                subject: mail_message[index].decodeSubject(),
                isAttachmentAvailable: mail_message[index].hasAttachments(),
                isChecked: !(mail_message[index].isFlagged),
                tagColor: Colors.red,
                time: mail_message[index].decodeDate().toString().substring(0,10),
                body: (!mail_message[index].isTextPlainMessage())
                    ? ' content-type: ${mail_message[index].mediaType}'
                    : mail_message[index].decodeTextPlainPart(),
                from_email: mail_message[index].fromEmail,
              ),
        );
      }
    return response;
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

}
