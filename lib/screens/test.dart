import 'package:email_client/services/authapi.dart';
import 'package:flutter/material.dart';

import 'login/login_screen.dart';

class Test extends StatelessWidget {
  const Test({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () async{
          await GoogleAuthApi.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        child: Text('Sign Out'),
      ),
    );
  }
}
