import 'package:email_client/Database/database_bin_emails_helper.dart';
import 'package:email_client/Database/database_draft_emails_helper.dart';
import 'package:email_client/Database/database_inbox_emails_helper.dart';
import 'package:email_client/Database/database_sent_emails_helper.dart';
import 'package:email_client/Database/database_user_helper.dart';
import 'package:email_client/models/emai_list_data.dart';
import 'package:email_client/models/user_data.dart';
import 'package:email_client/screens/login/login_screen.dart';
import 'package:email_client/services/authapi.dart';
import 'package:email_client/services/get_mail_imap.dart';
import 'package:flutter/material.dart';
import 'package:email_client/responsive.dart';
import 'package:provider/provider.dart';

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
                          padding: const EdgeInsets.fromLTRB(
                              kDefaultPadding - 5, 10, 10, 0),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                NetworkImage(UserData.userData.image),
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
                                UserData.userData.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kDefaultPadding - 15,
                            ),
                            Text(
                              UserData.userData.email,
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
                  Divider(
                    color: kPrimaryColor,
                    thickness: 3,
                    endIndent: 0,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                // padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  children: [
                    // Menu Items
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          kDefaultPadding - 5, 0, kDefaultPadding - 5, 0),
                      child: SideMenuItem(
                        press: () {
                          Provider.of<EmailListData>(context, listen: false).updateCurrentListToInboxList();
                          Navigator.pop(context);
                        },
                        title: "Inbox",
                        iconSrc: "assets/Icons/inbox.png",
                        isActive: true,
                        //itemCount: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          kDefaultPadding - 5, 0, kDefaultPadding - 5, 0),
                      child: SideMenuItem(
                        press: () {
                          Provider.of<EmailListData>(context, listen: false).updateCurrentListToSentList();
                          Navigator.pop(context);
                        },
                        title: "Sent",
                        iconSrc: "assets/Icons/send.png",
                        isActive: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          kDefaultPadding - 5, 0, kDefaultPadding - 5, 0),
                      child: SideMenuItem(
                        press: () {
                          Provider.of<EmailListData>(context, listen: false).updateCurrentListToDraftList();
                          Navigator.pop(context);
                        },
                        title: "Drafts",
                        iconSrc: "assets/Icons/file.png",
                        isActive: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          kDefaultPadding - 5, 0, kDefaultPadding - 5, 0),
                      child: SideMenuItem(
                        press: () {
                          Provider.of<EmailListData>(context, listen: false).updateCurrentListToBinList();
                          Navigator.pop(context);
                        },
                        title: "Deleted",
                        iconSrc: "assets/Icons/trash.png",
                        isActive: false,
                        showBorder: false,
                      ),
                    ),

                    SizedBox(height: kDefaultPadding * 2),
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
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      label: Text(
                        'Sign out',
                        style: TextStyle(
                            color: Colors.redAccent[700],
                            // fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      icon: Icon(
                        Icons.logout,
                        color: Colors.redAccent[700],
                        size: 20,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: kBgDarkColor,
                      ),
                      onPressed: () async {
                        await GoogleAuthApi.signOut();
                        await DatabaseUserHelper.instance.delete();
                        await DatabaseInboxEmailsHelper.instance.delete();
                        await DatabaseBinEmailsHelper.instance.delete();
                        await DatabaseSentEmailsHelper.instance.delete();
                        await DatabaseDraftEmailsHelper.instance.delete();
                        EmailListData.setNullEmailInboxList();
                        EmailListData.setNullEmailDraftList();
                        EmailListData.setNullEmailSentList();
                        EmailListData.setNullEmailBinList();
                        EmailListData.setNullCurrentEmailList();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                    ),
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
