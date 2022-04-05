import 'package:email_client/screens/loading_screen.dart';
import 'package:email_client/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_client/services/get_mail.dart';

GetMail mails= GetMail();

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

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
            // children = const <Widget>[
            //   SizedBox(
            //     width: 60,
            //     height: 60,
            //     child: CircularProgressIndicator(),
            //   ),
            //   Padding(
            //     padding: EdgeInsets.only(top: 16),
            //     child: Text('Awaiting result...'),
            //   )
            // ];
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