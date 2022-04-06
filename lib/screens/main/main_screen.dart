import 'package:flutter/material.dart';
import 'package:email_client/components/side_menu.dart';
import 'package:email_client/responsive.dart';
import 'package:email_client/models/Email.dart';
import 'package:email_client/screens/email/email_screen.dart';
import 'components/list_of_emails.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  List<Email> emails;
  MainScreen(List<Email> email) {
    emails=email;
  }

  @override
  Widget build(BuildContext context) {
    // It provide us the width and height
    Size _size = MediaQuery.of(context).size;
    print(emails[1].time);
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: ListOfEmails(emails: emails),
        tablet: Row(
          children: [
            Expanded(
              flex: 6,
              child: ListOfEmails(emails: emails),
            ),
            Expanded(
              flex: 9,
              child: EmailScreen(email: emails[emails.length-1]),
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
              child: ListOfEmails(emails: emails),
            ),
            Expanded(
              flex: _size.width > 1340 ? 7 : 10,
              child: EmailScreen(email: emails[emails.length-1]),
            ),
          ],
        ),
      ),
    );
  }
}
