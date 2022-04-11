// ignore_for_file: unnecessary_null_comparison

import 'package:email_client/screens/main/components/mail_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      appBar: AppBar(
        title: const Text('Auth'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Sign In'),
          onPressed: () async {
            bool user = await googleApi.authenticateUser();

            if(user) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MailLoader()),
              );
            }
            print('no user');
          },
        ),
      ),
    );
  }
}
