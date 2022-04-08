import 'package:email_client/screens/loading_screen.dart';
import 'package:email_client/screens/main/main_screen.dart';
import 'package:email_client/services/get_mail.dart';
import 'package:flutter/material.dart';

GetMail mails= GetMail();

class MailLoader extends StatefulWidget {
  const MailLoader({Key key}) : super(key: key);

  @override
  State<MailLoader> createState() => _MailLoaderState();
}

class _MailLoaderState extends State<MailLoader> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: mails.getEmail(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return MainScreen(mails.emails);
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
