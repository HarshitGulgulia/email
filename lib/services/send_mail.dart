import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'authapi.dart';



sendMail(String sendTo,String mailSubject,String mailText,List<String> mailAttachments) async {

  //also use for gmail smtp
  //final smtpServer = gmail(username, password);

  String token;
  token = await GoogleAuthApi.getToken();
  String email = GoogleAuthApi.getEmail();
  String username = GoogleAuthApi.getUsername();

  if(token==null||email==null){
    final bool tokenStatus = await GoogleAuthApi.generateRefreshToken();
    if(tokenStatus) {
      token = GoogleAuthApi.REFRESH_TOKEN;
      email = GoogleAuthApi.getEmail();
      username = GoogleAuthApi.getUsername();
    }
    else{
      await GoogleAuthApi.signOut();
      return 'Refresh Failed';
    }
  }

  final smtpServer = await gmailSaslXoauth2(email,token);

  final message = Message()
    ..from = Address(email, username)
    ..recipients.add(sendTo)
  //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
  //..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = mailSubject
    ..text = mailText;
  // ..html = "<h1>Kushagra</h1>\n<p>Hey! Here's some HTML content</p>"

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

}