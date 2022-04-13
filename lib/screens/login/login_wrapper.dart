import 'package:email_client/screens/login/login_screen.dart';
import 'package:email_client/screens/main/components/mail_loader.dart';

import 'package:email_client/services/authapi.dart';

import 'package:flutter/material.dart';
import 'package:email_client/screens/error/login_loader_error.dart';

import '../loading_screen.dart';

///Redirects the user on different pages from login page, in accordance to login status
class LoginWrapper extends StatelessWidget {
  const LoginWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<bool>(
        future: GoogleAuthApi.checkStatus(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData&&snapshot.data) {
            return MailLoader();
          } else if(snapshot.hasData&&!(snapshot.data)){
            return LoginScreen();
          } else if (snapshot.hasError) {
              return LoginLoadingError(error: snapshot);
          } else {
            return Loader();
          }
        },
      ),
    );
  }
}
