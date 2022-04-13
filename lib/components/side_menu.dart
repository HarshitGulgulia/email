import 'package:email_client/screens/login/login_screen.dart';
import 'package:email_client/services/authapi.dart';
import 'package:flutter/material.dart';
import 'package:email_client/responsive.dart';

import '../constants.dart';
import '../extensions.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

///Sidebar ui generator
class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/Tally-Prime-Logo.png",
                    height: 80,
                    width: 80,
                  ),
                  Spacer(),
                  // We don't want to show this close button on Desktop mood
                  if (!Responsive.isDesktop(context)) CloseButton(),
                ],
              ),
              SizedBox(height: kDefaultPadding),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                  ),
                  minimumSize: Size(double.infinity, 40),
                ),
                onPressed: () {},
                icon: Image.asset("assets/Icons/edit.png", width: 16),
                label: Text(
                  "Compose",
                  style: TextStyle(
                    fontSize: 16,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: kDefaultPadding * 2),
              // Menu Items
              SideMenuItem(
                press: () {},
                title: "Inbox",
                iconSrc: "assets/Icons/inbox.png",
                isActive: true,
                //itemCount: 3,
              ),
              SideMenuItem(
                press: () {},
                title: "Sent",
                iconSrc: "assets/Icons/send.png",
                isActive: false,
              ),
              SideMenuItem(
                press: () {},
                title: "Drafts",
                iconSrc: "assets/Icons/file.png",
                isActive: false,
              ),
              SideMenuItem(
                press: () {},
                title: "Deleted",
                iconSrc: "assets/Icons/trash.png",
                isActive: false,
                showBorder: false,
              ),

              SizedBox(height: kDefaultPadding * 2),
              ElevatedButton(
                  onPressed: () async{
                    await GoogleAuthApi.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
