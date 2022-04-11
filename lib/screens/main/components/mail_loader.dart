import 'package:email_client/screens/error/mail_loader_error.dart';
import 'package:email_client/screens/loading_screen.dart';
import 'package:email_client/screens/main/main_screen.dart';
import 'package:email_client/services/get_mail.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GetMail mails= GetMail();

class MailLoader extends StatefulWidget {
  const MailLoader({Key key, this.user}) : super(key: key);
  final GoogleSignInAccount user;
  @override
  State<MailLoader> createState() => _MailLoaderState();
}

///Loads user data when user launches the app
class _MailLoaderState extends State<MailLoader> {

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: mails.getEmail(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return MainScreen(mails.emails);
          } else if (snapshot.hasError) {
              return MailLoadingError(error: snapshot);
          } else {
            return Loader();
          }
        },
      ),
    );
  }
}
