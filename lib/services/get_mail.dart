
import 'package:email_client/Database/database_user_helper.dart';
import 'package:email_client/constants.dart';
import 'package:email_client/models/Email.dart';
import 'package:email_client/services/authapi.dart';
import 'package:enough_mail/enough_mail.dart';

import '../Database/database_emails_helper.dart';
import '../models/user.dart';

class GetMail {
  List<Email> emails;
  List<MimeMessage> mail_message;
  static String TOKEN;
  static User USERDETAILS;
  String imapServerHost = 'imap.gmail.com';
  int imapServerPort = 993;
  bool isImapServerSecure = true;

  Future<String> getImapEmailAuthenticate() async {
    final client = ImapClient(isLogEnabled: true);
    try {
      String token;
      if (await GoogleAuthApi.checkStatus()) {
        final bool tokenStatus = await GoogleAuthApi.generateRefreshToken();
        if (tokenStatus) {
          token = GoogleAuthApi.REFRESH_TOKEN;
          TOKEN = token;
        } else {
          await GoogleAuthApi.signOut();
          return 'Refresh Failed';
        }
      } else {
        token = await GoogleAuthApi.getToken();
        TOKEN = token;
      }
      final email = GoogleAuthApi.getEmail();
      TOKEN = token;
      await client.connectToServer(imapServerHost, imapServerPort,
          isSecure: isImapServerSecure);
      await client.authenticateWithOAuth2(email, token);
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
      return DATALOADED;
    } on ImapException catch (e) {
      print('IMAP failed with $e');
      return DATALOADINGERROR;
    }
  }

  Future<String> getEmailAPI() async {
    const i_c = '"';
    const a = '@';
    var response = await getImapEmailAuthenticate();
    if (response == DATALOADED) {
      emails = List.generate(
        mail_message.length,
        (index) => Email(
          name: mail_message[index].decodeSender().single.personalName == null
              ? mail_message[index].from.toString()[1] != '"'
                  ? mail_message[index].from.toString().substring(
                      1, mail_message[index].from.toString().indexOf(a))
                  : mail_message[index].from.toString().substring(
                      2, mail_message[index].from.toString().lastIndexOf(i_c))
              : mail_message[index].decodeSender().single.personalName,
          image: "assets/images/avatar.png",
          subject: mail_message[index].decodeSubject(),
          isAttachmentAvailable: mail_message[index].hasAttachments(),
          isChecked: !(mail_message[index].isFlagged),
          tagColor: null,
          time: mail_message[index].decodeDate().toString().substring(0, 10),
          body: mail_message[index].decodeTextHtmlPart() == null
              ? mail_message[index].decodeTextPlainPart()
              : ' ',
          from_email: mail_message[index].fromEmail,
          html: mail_message[index].decodeTextHtmlPart(),
        ),
      );
      for (var mail in emails) {
        Map<String, dynamic> json = mail.toJson();
        int i = await DatabaseEmailsHelper.instance.insert(json);
        print(i);
      }

      User user = GoogleAuthApi.getUser(TOKEN);
      USERDETAILS = user;
      Map<String, dynamic> json = user.toJson();
      print(json);
      int ui = await DatabaseUserHelper.instance.insertUser(json);
      print("user: $ui");
    }
    return response;
  }

  Future<String> getEmailDatabase() async {
    List<Map<String, dynamic>> rows =
        await DatabaseEmailsHelper.instance.queryAll();
    emails = List.generate(
      rows.length,
      (index) => Email(
        name: rows[index][DatabaseEmailsHelper.columnName],
        image: rows[index][DatabaseEmailsHelper.columnImage],
        subject: rows[index][DatabaseEmailsHelper.columnSubject],
        isAttachmentAvailable: (rows[index][DatabaseEmailsHelper.columnIsAttachmentAvailable] == 1) ? true : false,
        isChecked: (rows[index][DatabaseEmailsHelper.columnIsChecked] == 1) ? true : false,
        tagColor: null,
        time: rows[index][DatabaseEmailsHelper.columnTime],
        body: rows[index][DatabaseEmailsHelper.columnBody],
        html: rows[index][DatabaseEmailsHelper.columnHtml],
      ),
    );
    List<Map<String, dynamic>> users =
        await DatabaseUserHelper.instance.queryAllUser();
    print('users: $users');
    USERDETAILS = User(
        email: users[0][DatabaseUserHelper.columnEmail],
        name: users[0][DatabaseUserHelper.columnName],
        token: users[0][DatabaseUserHelper.columnToken],
        image: users[0][DatabaseUserHelper.columnImage]);
    print(USERDETAILS);
    return DATALOADED;
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
