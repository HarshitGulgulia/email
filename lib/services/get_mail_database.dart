
import 'package:email_client/Database/database_bin_emails_helper.dart';
import 'package:email_client/Database/database_draft_emails_helper.dart';
import 'package:email_client/Database/database_sent_emails_helper.dart';
import 'package:email_client/models/emai_list_data.dart';
import 'package:email_client/models/user_data.dart';

import '../Database/database_inbox_emails_helper.dart';
import '../Database/database_user_helper.dart';
import '../constants.dart';
import '../models/Email.dart';

class GetMailDatabase{

  static List<Email> emails;

  static Future<String> getEmailDatabase() async {


    List<Map<String, dynamic>> rows = await DatabaseInboxEmailsHelper.instance.queryAll();
    emails = ListGenerator.databaseJsonToEmailList(rows);
    EmailListData.setEmailInboxList(emails);
    EmailListData.setCurrentEmailList(emails);


    rows = await DatabaseSentEmailsHelper.instance.queryAll();
    emails = ListGenerator.databaseJsonToEmailList(rows);
    EmailListData.setEmailSentList(emails);

    rows = await DatabaseBinEmailsHelper.instance.queryAll();
    emails = ListGenerator.databaseJsonToEmailList(rows);
    EmailListData.setEmailBinList(emails);

    rows = await DatabaseDraftEmailsHelper.instance.queryAll();
    emails = ListGenerator.databaseJsonToEmailList(rows);
    EmailListData.setEmailDraftList(emails);


    List<Map<String, dynamic>> users =
    await DatabaseUserHelper.instance.queryAllUser();
    print('users: $users');
    UserData.setUserData(
        users[0][DatabaseUserHelper.columnEmail],
        users[0][DatabaseUserHelper.columnToken],
        users[0][DatabaseUserHelper.columnImage],
      users[0][DatabaseUserHelper.columnName]
    );

    return DATALOADED;
  }

}
