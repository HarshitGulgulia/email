import 'package:email_client/screens/loading_screen.dart';
import 'package:email_client/screens/login/login_screen.dart';
import 'package:email_client/screens/login/login_wrapper.dart';
import 'package:email_client/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_client/services/get_mail.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginWrapper();
  }
}


// DefaultTextStyle(
// style: Theme.of(context).textTheme.headline2,
// textAlign: TextAlign.center,
// child: FutureBuilder<String>(
// future: mails.getEmail(), // a previously-obtained Future<String> or null
// builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
// List<Widget> children;
// if (snapshot.hasData) {
// return LoginScreen(emails: mails.emails);
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