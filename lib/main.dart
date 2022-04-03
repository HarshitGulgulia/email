import 'dart:io';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';

String userName = '1mv20is021@sirmvit.edu';
String password = 'Hg@sirmvit';
String imapServerHost = 'imap.gmail.com';
int imapServerPort = 993;
bool isImapServerSecure = true;
late List<MimeMessage> mail_message;


void main(){
  imapExample();
  runApp(MaterialApp(
      home: const email_list()
  ));
}


/// Low level IMAP API usage example
Future<void> imapExample() async {
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
    await client.logout();
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

class email_list extends StatefulWidget {
  const email_list({Key? key}) : super(key: key);

  @override
  State<email_list> createState() => _email_listState();
}

class _email_listState extends State<email_list> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Email List'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: ListView.builder(
            itemCount: 31,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: Card(
                  color: Colors.lightBlueAccent,
                  child: ListTile(
                    onTap: () {
                      //imapExample();
                    },
                    title: Text(mail_message[index].fromEmail.toString()),
                    textColor: Colors.white,
                    ),
                  ),
                );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //imapExample();
        },
      ),
    );
  }
}
