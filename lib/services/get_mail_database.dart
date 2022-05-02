import 'package:email_client/models/email_list_data.dart';
import 'package:email_client/models/user_data.dart';
import 'package:email_client/services/authapi.dart';
import 'package:email_client/services/get_mail_imap.dart';
import '../Database/database_inbox_emails_helper.dart';
import '../Database/database_user_helper.dart';
import '../constants.dart';
import '../models/Email.dart';
import '../../Database/database_bin_emails_helper.dart';
import '../../Database/database_draft_emails_helper.dart';
import '../../Database/database_sent_emails_helper.dart';


class GetMailDatabase {
  static List<Email> emails;

  static Future<String> getEmailDatabase() async {
    List<Map<String, dynamic>> rows =
        await DatabaseInboxEmailsHelper.instance.queryAll();
    emails = ListGenerator.databaseJsonToEmailList(rows);
    EmailListData.setEmailInboxList(emails);
    EmailListData.setCurrentEmailList(emails);

    rows = await DatabaseSentEmailsHelper.instance.queryAll();
    emails = ListGenerator.databaseJsonToEmailList(rows);
    EmailListData.setEmailSentList(emails);

    rows = await DatabaseDraftEmailsHelper.instance.queryAll();
    emails = ListGenerator.databaseJsonToEmailList(rows);
    EmailListData.setEmailDraftList(emails);

    rows = await DatabaseBinEmailsHelper.instance.queryAll();
    emails = ListGenerator.databaseJsonToEmailList(rows);
    EmailListData.setEmailBinList(emails);

    List<Map<String, dynamic>> users =
        await DatabaseUserHelper.instance.queryAllUser();
    print('users: $users');
    await GoogleAuthApi.generateRefreshToken();
    UserData.setUserData(
        users[0][DatabaseUserHelper.columnEmail],
        GoogleAuthApi.REFRESH_TOKEN,
        users[0][DatabaseUserHelper.columnImage],
        users[0][DatabaseUserHelper.columnName]);
    await GetMailIMAP.getImapEmailAuthenticate();
    GetMailIMAP.new_inbox(Command.Client);
    return DATALOADED;
  }
}
