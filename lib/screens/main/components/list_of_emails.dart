import 'package:flutter/material.dart';
import 'package:email_client/components/side_menu.dart';
import 'package:email_client/models/Email.dart';
import 'package:email_client/responsive.dart';
import 'package:email_client/screens/email/email_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/emai_list_data.dart';
import 'email_card.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ListOfEmails extends StatefulWidget {
  // Press "Command + ."

  const ListOfEmails({
    Key key,
  }) : super(key: key);

  @override
  _ListOfEmailsState createState() => _ListOfEmailsState();
}

///Build List of Email ui using ListBuilder. Takes Email<List> as constructor parameter.
class _ListOfEmailsState extends State<ListOfEmails> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var emailList = Provider.of<EmailListData>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Search bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    // Once user click the menu icon the menu shows like drawer
                    // Also we want to hide this menu icon on desktop
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                    //SizedBox is Humburgericon size
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),


                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,10,0,0),
                        child: TextField(
                          onChanged: (value) {/*Search to be implemented here*/},
                          decoration: InputDecoration(
                            hintText: "Search",
                            fillColor: kBgLightColor,
                            filled: true,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(
                                  kDefaultPadding * 0.75), //15
                              child: Image.asset(
                                "assets/Icons/search.png",
                                width: 24,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: kDefaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: emailList.EmailList.length,
                  // On mobile this active dosen't mean anything
                  itemBuilder: (context, index) => EmailCard(
                    isActive: Responsive.isMobile(context) ? false : index == 0,
                    email: emailList.EmailList[Provider.of<EmailListData>(context).EmailList.length-1-index],
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EmailScreen(email: emailList.EmailList[emailList.EmailList.length-1-index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
