import 'package:email_client/models/emai_list_data.dart';
import 'package:email_client/screens/error/mail_loader_error.dart';
import 'package:email_client/screens/loading_screen.dart';
import 'package:email_client/screens/login/login_wrapper.dart';
import 'package:email_client/screens/main/main_screen.dart';
import 'package:email_client/services/get_mail_database.dart';
import 'package:email_client/services/get_mail_imap.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class MailLoader extends StatefulWidget {
  const MailLoader({Key key, this.user, this.user_signed_in}) : super(key: key);
  final GoogleSignInAccount user;
  final bool user_signed_in;
  @override
  State<MailLoader> createState() => _MailLoaderState();
}

///Loads user data when user launches the app
class _MailLoaderState extends State<MailLoader> {
  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return ChangeNotifierProvider<EmailListData>(
        create: (context) => EmailListData(),
        child: FutureBuilder<String>(
          future: (widget.user_signed_in)?GetMailDatabase.getEmailDatabase():GetMailIMAP.getEmailAPI(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return MainScreen();
            } else if (snapshot.hasData && snapshot.data == 'Refresh Failed') {
              return LoginWrapper();
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

//
