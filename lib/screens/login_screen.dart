// ignore_for_file: unnecessary_null_comparison

import 'package:email_client/models/Email.dart';
import 'package:email_client/screens/mail_loader.dart';
import 'package:email_client/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import '../services/authapi.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key, this.emails}) : super(key: key);

  final List<Email> emails;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future<bool> authenticateUser () async{
    final user = await GoogleAuthApi.signIn();
    print(user);
    if (user == null) {
      return false;
    }
    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken;
    print(email);
    print(token);
    return await GoogleAuthApi.checkStatus();
  }

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
            bool user = await authenticateUser();
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

// Navigator.pushReplacement(
// context,
// MaterialPageRoute(
// builder: (context) => MyApp(),
// ),
// );