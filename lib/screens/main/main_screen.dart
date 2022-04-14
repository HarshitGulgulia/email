import 'package:email_client/constants.dart';
import 'package:email_client/main.dart';
import 'package:flutter/material.dart';
import 'package:email_client/components/side_menu.dart';
import 'package:email_client/responsive.dart';
import 'package:email_client/models/Email.dart';
import 'package:email_client/screens/email/email_screen.dart';
import 'components/compose_email.dart';
import 'components/list_of_emails.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  List<Email> emails;
  MainScreen(List<Email> email) {
    emails = email;
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}
///Main Screen of email client ui with three components- ListOfEmails, EmailScreen, SideMenu. Takes Email<List> as constructor parameter.
class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    //print(widget.emails[1].time);
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: ListOfEmails(emails: widget.emails),
        tablet: Row(
          children: [
            Expanded(
              flex: 6,
              child: ListOfEmails(emails: widget.emails),
            ),
            Expanded(
              flex: 9,
              child:
                  EmailScreen(email: widget.emails[widget.emails.length - 1]),
            ),
          ],
        ),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: SideMenu(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ListOfEmails(emails: widget.emails),
            ),
            Expanded(
              flex: _size.width > 1340 ? 7 : 10,
              child:
                  EmailScreen(email: widget.emails[widget.emails.length - 1]),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create_sharp),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Compose(),
            ),
          );
        },
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
