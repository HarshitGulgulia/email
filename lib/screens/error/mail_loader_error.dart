
import 'package:flutter/material.dart';

import '../../services/authapi.dart';
import '../login/login_screen.dart';

///Stateless widget for showing error while loading mail from server
class MailLoadingError extends StatelessWidget {
  const MailLoadingError({Key key, this.error}) : super(key: key);
  final AsyncSnapshot<String> error;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${error.error}'),
            ),
            ElevatedButton(
              onPressed: () async{
                await GoogleAuthApi.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Sign Out'),
            ),

          ] ,
        ),
      ),
    );;
  }
}

