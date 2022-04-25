// ignore_for_file: unnecessary_null_comparison

import 'package:email_client/screens/main/components/mail_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../constants.dart';
import '../../services/authapi.dart';

GoogleAuthApi googleApi = GoogleAuthApi();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

///Login Screen ui builder with google sign-in provider
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: SizedBox(
            height: 450,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                  child: SignInButton(
                    Buttons.Google,
                    text: "Sign in with Google",
                    onPressed: () async {
                      bool user = await googleApi.authenticateUser();
                      print(user);
                      if (user) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MailLoader(user_signed_in: false)),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
