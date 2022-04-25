import 'package:email_client/Database/store_to_db.dart';
import 'package:email_client/constants.dart';
import 'package:email_client/models/Email.dart';
import 'package:email_client/models/user_data.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:email_client/logs/log_functions.dart';
import '../models/email_list_data.dart';

class GetMailIMAP {
  static List<Email> inboxEmails,sentEmails,draftEmails,binEmails;
  static List<MimeMessage> inbox_message;
  static List<MimeMessage> sent_message;
  static List<MimeMessage> draft_message;
  static List<MimeMessage> bin_message;

  static String imapServerHost = IMAPHOSTSERVER;
  static int imapServerPort = IMAPSERVERPORT;
  static bool isImapServerSecure = ISIMAPSERVERSECURE;

  static Future<String> fetchInbox(ImapClient client) async {
    try {
      Mailbox box = await client.selectInbox();
      if (box.messagesExists == 0) {
        return "Zero";
      }
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 30, criteria: 'BODY.PEEK[]');
      inbox_message = fetchResult.messages;

      // for (final message in fetchResult.messages) {
      //   Log.printMessage(message);
      // }

      return DATALOADED;
    } catch (e) {
      return DATALOADINGERROR;
    }
  }

  static Future<String> fetchSentMail(ImapClient client) async {
    try {
      Mailbox box = await client.selectMailboxByPath("[Gmail]/Sent Mail");
      if (box.messagesExists == 0) {
        return "Zero";
      }
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 15, criteria: 'BODY.PEEK[]');
      sent_message = fetchResult.messages;

      // for (final message in fetchResult.messages) {
      //   Log.printMessage(message);
      // }

      return DATALOADED;
    } catch (e) {
      return DATALOADINGERROR;
    }
  }

  static Future<String> fetchDrafts(ImapClient client) async {
    try {
      Mailbox box = await client.selectMailboxByPath("[Gmail]/Drafts");
      if (box.messagesExists == 0) {
        return "Zero";
      }
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 15, criteria: 'BODY.PEEK[]');
      draft_message = fetchResult.messages;
      // for (final message in fetchResult.messages) {
      //   Log.printMessage(message);
      // }

      return DATALOADED;
    } catch (e) {
      return DATALOADINGERROR;
    }
  }

  static Future<String> fetchBin(ImapClient client) async {
    try {
      Mailbox box = await client.selectMailboxByPath("[Gmail]/${Command.Bin}");
      if (box.messagesExists == 0) {
        return 'Zero';
      }
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 15, criteria: 'BODY.PEEK[]');
      bin_message = fetchResult.messages;

      // for (final message in fetchResult.messages) {
      //   Log.printMessage(message);
      // }

      return DATALOADED;
    } catch (e) {
      return DATALOADINGERROR;
    }
  }

  ///only authenticate the imap server to connect to..
  static Future<String> getImapEmailAuthenticate() async {
    final client = ImapClient(isLogEnabled: true);
    Command.setClient(client);
    try {
      final token = UserData.userData.token;
      final email = UserData.userData.email;
      await client.connectToServer(imapServerHost, imapServerPort,
          isSecure: isImapServerSecure);
      await client.authenticateWithOAuth2(email, token);
      final mailboxes = await client.listMailboxes();
      print('mailboxes: $mailboxes');
      await fetchInbox(client);
      await fetchSentMail(client);
      await fetchDrafts(client);
      await fetchBin(client);

      return DATALOADED;
    } on ImapException catch (e) {
      print('IMAP failed with $e');
      return DATALOADINGERROR;
    }
  }

  static Future<String> saveToDB(var response) async {
    if (response == DATALOADED) {

      //List of emails is stored to database

      if(inbox_message!=null) {
        inboxEmails =
            ListGenerator.mimemessageToEmailList(inbox_message, 'inbox');
        EmailListData.setEmailInboxList(inboxEmails);
        EmailListData.setCurrentEmailList(inboxEmails);
        await StoreToDB.storeInboxMailList(inboxEmails);
      }

      if(draft_message!=null) {
        draftEmails =
            ListGenerator.mimemessageToEmailList(draft_message, 'draft');
        EmailListData.setEmailDraftList(draftEmails);
        await StoreToDB.storeDraftMailList(draftEmails);
      }

      if(sent_message!=null) {
        sentEmails = ListGenerator.mimemessageToEmailList(sent_message, 'sent');
        EmailListData.setEmailSentList(sentEmails);
        await StoreToDB.storeSentMailList(sentEmails);
      }

      if(bin_message==null){
        Command.setTrash();
        await fetchBin(Command.Client);
        Command.setBin();
      }

      if(bin_message!=null) {
        binEmails = ListGenerator.mimemessageToEmailList(bin_message, 'bin');
        EmailListData.setEmailBinList(binEmails);
        await StoreToDB.storeBinMailList(binEmails);
      }

      //user data is stored to database
      await StoreToDB.storeUser();
    } else {
      response = DATALOADINGERROR;
    }
    return response;
  }

  static Future<String> getEmailAPI() async {
    var response = await getImapEmailAuthenticate();
    response = await saveToDB(response);
    return response;
  }
}
