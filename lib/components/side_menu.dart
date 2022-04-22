import 'package:email_client/Database/database_helper.dart';
import 'package:email_client/screens/login/login_screen.dart';
import 'package:email_client/screens/main/components/compose_email.dart';
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
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(kDefaultPadding-5,10,10,0),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(GoogleAuthApi.getPhotoUrl()),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                GoogleAuthApi.getUsername(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: kDefaultPadding-15,),
                            Text(
                              GoogleAuthApi.getEmail(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // We don't want to show this close button on Desktop mood
                      // if (!Responsive.isDesktop(context)) CloseButton(),
                    ],
                  ),
                  Divider(color: kPrimaryColor,thickness: 3,endIndent: 0,),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                // padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  children: [

                    // SizedBox(height: kDefaultPadding-10),
                    // ElevatedButton.icon(
                    //   style: ElevatedButton.styleFrom(
                    //     primary: kPrimaryColor,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: kDefaultPadding,
                    //     ),
                    //     minimumSize: Size(double.infinity, 40),
                    //   ),
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => Compose(),
                    //       ),
                    //     );
                    //   },
                    //   icon: Image.asset("assets/Icons/edit.png", width: 16),
                    //   label: Text(
                    //     "Compose",
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //         color: Colors.white),
                    //   ),
                    // ),
                    // Menu Items
                    Padding(
                      padding: const EdgeInsets.fromLTRB(kDefaultPadding-5, 0, kDefaultPadding-5, 0),
                      child: SideMenuItem(
                        press: () {},
                        title: "Inbox",
                        iconSrc: "assets/Icons/inbox.png",
                        isActive: true,
                        //itemCount: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(kDefaultPadding-5, 0, kDefaultPadding-5, 0),
                      child: SideMenuItem(
                        press: () {},
                        title: "Sent",
                        iconSrc: "assets/Icons/send.png",
                        isActive: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(kDefaultPadding-5, 0, kDefaultPadding-5, 0),
                      child: SideMenuItem(
                        press: () {},
                        title: "Drafts",
                        iconSrc: "assets/Icons/file.png",
                        isActive: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(kDefaultPadding-5, 0, kDefaultPadding-5, 0),
                      child: SideMenuItem(
                        press: () {},
                        title: "Deleted",
                        iconSrc: "assets/Icons/trash.png",
                        isActive: false,
                        showBorder: false,
                      ),
                    ),

                    SizedBox(height: kDefaultPadding * 2),
                    // ElevatedButton(
                    //     onPressed: () async{
                    //       await GoogleAuthApi.signOut();
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => LoginScreen()),
                    //       );
                    //     },
                    //     child: Text('Sign Out'),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: kPrimaryColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              color: kBgDarkColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.logout,color: Colors.redAccent[700],size: 30,),
                    onPressed: () async{
                      await GoogleAuthApi.signOut();
                      await DatabaseHelper.instance.delete();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
    //   label: Text(
                  //     'Sign out',
                  //   style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
                  // ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
