import 'package:flutter/material.dart';
import 'package:email_client/components/side_menu.dart';
import 'package:email_client/models/Email.dart';
import 'package:email_client/responsive.dart';
import 'package:email_client/screens/email/email_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import 'email_card.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ListOfEmails extends StatefulWidget {
  // Press "Command + ."

  const ListOfEmails({
    Key key, this.emails,
  }) : super(key: key);

  final List<Email> emails;

  @override
  _ListOfEmailsState createState() => _ListOfEmailsState();
}

class _ListOfEmailsState extends State<ListOfEmails> {



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/Icons/angledown.png",
                      width: 16,
                      color: Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Sort by date",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    MaterialButton(
                      minWidth: 20,
                      onPressed: () {},
                      child: Image.asset(
                        "assets/Icons/sort.png",
                        width: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.emails.length,
                  reverse: true,
                  // On mobile this active dosen't mean anything
                  itemBuilder: (context, index) => EmailCard(
                    isActive: Responsive.isMobile(context) ? false : index == 0,
                    email: widget.emails[index],
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EmailScreen(email: widget.emails[index]),
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
