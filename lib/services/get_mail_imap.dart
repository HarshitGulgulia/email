import 'package:email_client/Database/store_to_db.dart';
import 'package:email_client/constants.dart';
import 'package:email_client/models/Email.dart';
import 'package:email_client/models/user_data.dart';
import 'package:enough_mail/enough_mail.dart';

import 'package:email_client/logs/log_functions.dart';
import '../models/emai_list_data.dart';

class GetMailIMAP {
  static List<Email> inboxEmails,draftEmails,sentEmails,binEmails;
  static List<MimeMessage> inbox_message;
  static List<MimeMessage> sent_message;
  static List<MimeMessage> draft_message;
  static List<MimeMessage> bin_message;

  static String imapServerHost = IMAPHOSTSERVER;
  static int imapServerPort = IMAPSERVERPORT;
  static bool isImapServerSecure = ISIMAPSERVERSECURE;

  static void fetchInbox(ImapClient client) async {
    await client.selectInbox();
    final fetchResult = await client.fetchRecentMessages(
        messageCount: 30, criteria: 'BODY.PEEK[]');
    inbox_message = fetchResult.messages;

    for (final message in fetchResult.messages) {
      Log.printMessage(message);
    }
  }

  static void fetchSentMail(ImapClient client) async {
    await client.selectMailboxByPath("[Gmail]/Sent Mail");
    final fetchResult = await client.fetchRecentMessages(
        messageCount: 15, criteria: 'BODY.PEEK[]');
    sent_message = fetchResult.messages;

    for (final message in fetchResult.messages) {
      Log.printMessage(message);
    }
  }

  static void fetchDrafts(ImapClient client) async {
    await client.selectMailboxByPath("[Gmail]/Drafts");
    final fetchResult = await client.fetchRecentMessages(
        messageCount: 15, criteria: 'BODY.PEEK[]');
    draft_message = fetchResult.messages;

    for (final message in fetchResult.messages) {
      Log.printMessage(message);
    }
  }

  static void fetchBin(ImapClient client) async {
    await client.selectMailboxByPath("[Gmail]/Bin");
    final fetchResult = await client.fetchRecentMessages(
        messageCount: 15, criteria: 'BODY.PEEK[]');
    bin_message = fetchResult.messages;

    for (final message in fetchResult.messages) {
      Log.printMessage(message);
    }
  }

  ///only authenticate the imap server to connect to..
  static Future<String> getImapEmailAuthenticate() async {
    final client = ImapClient(isLogEnabled: true);
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

  static Future<String> getEmailAPI() async {

    var response = await getImapEmailAuthenticate();
    if (response == DATALOADED) {
      inboxEmails = ListGenerator.mimemessageToEmailList(inbox_message,'inbox');
      EmailListData.setEmailInboxList(inboxEmails);
      EmailListData.setCurrentEmailList(inboxEmails);

      draftEmails = ListGenerator.mimemessageToEmailList(draft_message,'draft');
      EmailListData.setEmailDraftList(draftEmails);

      binEmails = ListGenerator.mimemessageToEmailList(bin_message,'bin');
      EmailListData.setEmailBinList(binEmails);

      sentEmails = ListGenerator.mimemessageToEmailList(sent_message,'sent');
      EmailListData.setEmailSentList(sentEmails);
      
      //List of emails is stored to database
      await StoreToDB.storeMailList(inboxEmails);
      //user data is stored to database
      await StoreToDB.storeUser();
    }
    return response;
  }

}

