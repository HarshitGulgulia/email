import 'package:email_client/screens/login_screen.dart';
import 'package:email_client/screens/mail_loader.dart';

import 'package:email_client/services/authapi.dart';

import 'package:flutter/material.dart';

import 'loading_screen.dart';

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
          List<Widget> children;
          if (snapshot.hasData&&snapshot.data) {
            return MailLoader();
          } else if(snapshot.hasData&&!(snapshot.data)){
            return LoginScreen();
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
            return Loader();
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

// FutureBuilder<bool>(
// future: GoogleAuthApi.checkStatus(), // a previously-obtained Future<String> or null
// builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
// List<Widget> children;
// if (snapshot.hasData&&snapshot.data) {
// return MailLoader();
// } else if(snapshot.hasData&&!(snapshot.data)){
// return LoginScreen();
// } else if (snapshot.hasError) {
// children = <Widget>[
// const Icon(
// Icons.error_outline,
// color: Colors.red,
// size: 60,
// ),
// Padding(
// padding: const EdgeInsets.only(top: 16),
// child: Text('Error: ${snapshot.error}'),
// )
// ];
// } else {
// return Loader();
// }
// return Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: children,
// ),
// );
// },
// ),
// );