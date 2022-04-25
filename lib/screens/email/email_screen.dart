import 'package:email_client/screens/email/components/email_screen_details.dart';
import 'package:flutter/material.dart';
import 'package:email_client/models/Email.dart';
import '../../constants.dart';
import 'components/header.dart';
import 'components/web_view.dart';

///Email Screen UI which contains all the data fetched using IMAP. Takes Email as constructor parameter.
class EmailScreen extends StatefulWidget {
  const EmailScreen({
    Key key,
    this.email,
  }) : super(key: key);

  final Email email;

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Header(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EmailScreenDetails(email: widget.email),
                      SizedBox(height: kDefaultPadding),
                      SizedBox(
                        child: Text(
                          widget.email.body,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF4D5875),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      WebViewScreen(email: widget.email),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
