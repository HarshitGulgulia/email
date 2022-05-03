import 'package:flutter/material.dart';
import 'package:email_client/components/side_menu.dart';
import 'package:email_client/responsive.dart';
import 'package:email_client/screens/email/email_screen.dart';
import 'package:provider/provider.dart';
import '../../../Database/database_bin_emails_helper.dart';
import '../../../Database/database_draft_emails_helper.dart';
import '../../../Database/database_inbox_emails_helper.dart';
import '../../../Database/database_sent_emails_helper.dart';
import '../../../Database/database_user_helper.dart';
import '../../../constants.dart';
import '../../../models/email_list_data.dart';
import '../../../services/get_mail_imap.dart';
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
    CONTEXT = context;
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
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextField(
                          onChanged: (value) {
                            /*Search to be implemented here*/
                          },
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                child: RefreshIndicator(
                  child: ListView.builder(
                    itemCount: emailList.EmailList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) => EmailCard(
                      isActive:
                          Responsive.isMobile(context) ? false : index == 0,
                      email: emailList.EmailList[
                          Provider.of<EmailListData>(context).EmailList.length -
                              1 -
                              index],
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailScreen(
                                email: emailList.EmailList[
                                    emailList.EmailList.length - 1 - index]),
                          ),
                        );
                      },
                    ),
                  ),
                  onRefresh: () async {
                    // setState(() {
                    // });
                    await DatabaseUserHelper.instance.delete();
                    await DatabaseInboxEmailsHelper.instance.delete();
                    await DatabaseSentEmailsHelper.instance.delete();
                    await DatabaseDraftEmailsHelper.instance.delete();
                    await DatabaseBinEmailsHelper.instance.delete();
                    await EmailListData.setNullEmailInboxList();
                    await EmailListData.setNullEmailDraftList();
                    await EmailListData.setNullEmailSentList();
                    await EmailListData.setNullEmailBinList();
                    await GetMailIMAP.fetchMail(DATALOADED);
                    Provider.of<EmailListData>(context, listen: false)
                        .updateCurrentListToInboxList();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Mails Refreshed',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
