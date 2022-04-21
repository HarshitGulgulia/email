import 'package:email_client/models/Email.dart';
import 'package:email_client/services/authapi.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';

class GetMail {
  List<Email> emails;
  List<MimeMessage> mail_message;

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
        } else {
          await GoogleAuthApi.signOut();
          return 'Refresh Failed';
        }
      } else {
        token = await GoogleAuthApi.getToken();
      }
      final email = GoogleAuthApi.getEmail();
      print(email);
      print(token);
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
      return 'Data Loaded';
    } on ImapException catch (e) {
      print('IMAP failed with $e');
      return 'error';
    }
  }

  // Future<String> authenticate(ServerConfig serverConfig,
  //     {ImapClient? imap, PopClient? pop, SmtpClient? smtp}) async {
  //   final name = userName!;
  //   final tkn = token!;
  //   switch (serverConfig.type) {
  //     case ServerType.imap:
  //       await imap!.authenticateWithOAuth2(name, tkn);
  //       break;
  //     case ServerType.pop:
  //       await pop!.login(name, tkn);
  //       break;
  //     case ServerType.smtp:
  //       await smtp!.authenticate(name, tkn, AuthMechanism.xoauth2);
  //       break;
  //     default:
  //       throw StateError('Unknown server type ${serverConfig.typeName}');
  //   }
  // }

  //Function without OAuth Mechanism
  /*Future<String> getImapEmailLogin() async {
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
      return 'Data Loaded';  //create a separate file for global keys and variables
    } on ImapException catch (e) {
      print('IMAP failed with $e');
      return 'error';
    }
  }*/

  Future<String> getEmail() async {
    const i_c = '"';
    const a = '@';
    var response = await getImapEmailAuthenticate();
    if (response == 'Data Loaded') {
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
