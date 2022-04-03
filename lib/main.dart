import 'package:email_client/screens/main/main_screen.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';

import 'models/Email.dart';

String userName = '1mv20is021@sirmvit.edu';
String password = 'Hg@sirmvit';
String imapServerHost = 'imap.gmail.com';
int imapServerPort = 993;
bool isImapServerSecure = true;
List<MimeMessage> mail_message;

Future<String> imapExample() async {
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
    await client.logout();
    return 'Data Loaded';
  } on ImapException catch (e) {
    print('IMAP failed with $e');
    return 'error';
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

// import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // final Future<String> _calculation = Future<String>.delayed(
  //   const Duration(seconds: 2),
  //       () => 'Data Loaded',
  // );
  // Future<String> _calculation() async{
  //   final client = ImapClient(isLogEnabled: true);
  //   await client.connectToServer(imapServerHost, imapServerPort, isSecure: isImapServerSecure);
  //   //await Future.delayed(const Duration(seconds: 2));
  //   await Future.delayed(const Duration(seconds: 2));
  //   return 'Data Loaded';
  // }
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: imapExample(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {

            List<Email> emails = List.generate(
              mail_message.length,
              (index) => Email(
                name: mail_message[index].decodeSender().first.toString(),
                image: "assets/images/user_1.png",
                subject: mail_message[index].decodeSubject(),
                isAttachmentAvailable: mail_message[index].hasAttachments(),
                isChecked: mail_message[index].isSeen,
                tagColor: Colors.red,
                time: mail_message[index].decodeDate().toString(),
                body: (!mail_message[index].isTextPlainMessage())?' content-type: ${mail_message[index].mediaType}':mail_message[index].decodeTextPlainPart(),
                from_email: mail_message[index].fromEmail,
              ),
            );
            return MainScreen(emails);
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
