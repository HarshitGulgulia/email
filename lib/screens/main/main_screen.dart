import 'package:email_client/constants.dart';
import 'package:email_client/screens/main/components/no_mail_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_client/components/side_menu.dart';
import 'package:email_client/responsive.dart';
import 'package:email_client/screens/email/email_screen.dart';
import 'package:provider/provider.dart';
import '../../models/email_list_data.dart';
import 'components/compose_email.dart';
import 'components/list_of_emails.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

///Main Screen of email client ui with three components- ListOfEmails, EmailScreen, SideMenu. Takes Email<List> as constructor parameter.
class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    // It provide us the width and height

    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        // Let's work on our mobile part
        mobile: FutureBuilder<bool>(
          future: Provider.of<EmailListData>(context).checkMailExist(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              print(snapshot.data);
              print('in list of emails');
              return ListOfEmails();
            }
            else {
              print(snapshot.data);
              return NoMail();
            }
          },
        ),
        tablet: Row(
          children: [
            Expanded(
              flex: 6,
              child: FutureBuilder<bool>(
                future: Provider.of<EmailListData>(context).checkMailExist(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return ListOfEmails();
                  }
                  else {
                    return NoMail();
                  }
                },
              ),
            ),
            Expanded(
              flex: 9,
              child: FutureBuilder<bool>(
                future: Provider.of<EmailListData>(context).checkMailExist(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return EmailScreen(
                        email: Provider.of<EmailListData>(context).EmailList[
                        Provider.of<EmailListData>(context).EmailList.length -
                            1]);
                  }
                  else {
                    return NoMail();
                  }
                },
              ),
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
              child: FutureBuilder<bool>(
                future: Provider.of<EmailListData>(context).checkMailExist(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return ListOfEmails();
                  }
                  else {
                    return NoMail();
                  }
                },
              ),
            ),
            Expanded(
              flex: _size.width > 1340 ? 7 : 10,
              child: FutureBuilder<bool>(
                future: Provider.of<EmailListData>(context).checkMailExist(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return EmailScreen(
                        email: Provider.of<EmailListData>(context).EmailList[
                        Provider.of<EmailListData>(context).EmailList.length -
                            1]);
                  }
                  else {
                    return NoMail();
                  }
                },
              ),
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
