import 'package:email_client/Database/store_to_db.dart';
import 'package:email_client/constants.dart';
import 'package:email_client/models/Email.dart';
import 'package:email_client/models/user_data.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:email_client/logs/log_functions.dart';
import 'package:provider/provider.dart';
import '../models/email_list_data.dart';

class GetMailIMAP {
  static List<Email> inboxEmails, sentEmails, draftEmails, binEmails;
  static List<MimeMessage> inbox_message;
  static List<MimeMessage> new_message;
  static List<MimeMessage> sent_message;
  static List<MimeMessage> draft_message;
  static List<MimeMessage> bin_message;

  static String imapServerHost = IMAPHOSTSERVER;
  static int imapServerPort = IMAPSERVERPORT;
  static bool isImapServerSecure = ISIMAPSERVERSECURE;

  static new_inbox(MailClient client) async {
    await client.selectInbox();
    client.eventBus.on<MailLoadEvent>().listen((event) async {
      print('New message at ${DateTime.now()}:');
      final fetchNewMessage = await client.fetchMessages(count: 0);
      new_message = fetchNewMessage;
      List<Email> emailsList;
      emailsList = ListGenerator.mimemessageToEmailList(new_message, 'inbox');
      StoreToDB.storeInboxMailList(emailsList);
      await EmailListData.addToCurrentListToInboxList(emailsList[0]);
      Provider.of<EmailListData>(CONTEXT, listen: false)
          .updateCurrentListToInboxList();
      //Log.printMessage(inbox_message.first);
      //Log.printMessage(event.message);
    });
    await client.startPolling();
  }

  static Future<String> fetchInbox(MailClient client) async {
    try {
      Mailbox box = await client.selectInbox();
      if (box.messagesExists == 0) {
        return "Zero";
      }
      final fetchResult = await client.fetchMessages(count: 30);
      inbox_message = fetchResult;

      // for (final message in fetchResult.messages) {
      //   Log.printMessage(message);
      // }

      return DATALOADED;
    } catch (e) {
      return DATALOADINGERROR;
    }
  }

  static Future<String> fetchSentMail(MailClient client) async {
    try {
      Mailbox box = await client.selectMailboxByPath("[Gmail]/Sent Mail");
      if (box.messagesExists == 0) {
        return "Zero";
      }
      final fetchResult = await client.fetchMessages(count: 10);
      sent_message = fetchResult;

      // for (final message in fetchResult.messages) {
      //   Log.printMessage(message);
      // }

      return DATALOADED;
    } catch (e) {
      return DATALOADINGERROR;
    }
  }

  static Future<String> fetchDrafts(MailClient client) async {
    try {
      Mailbox box = await client.selectMailboxByPath("[Gmail]/Drafts");
      if (box.messagesExists == 0) {
        return "Zero";
      }
      final fetchResult = await client.fetchMessages(count: 10);
      draft_message = fetchResult;

      // for (final message in fetchResult.messages) {
      //   Log.printMessage(message);
      // }

      return DATALOADED;
    } catch (e) {
      return DATALOADINGERROR;
    }
  }

  static Future<String> fetchBin(MailClient client) async {
    try {
      Mailbox box = await client.selectMailboxByPath("[Gmail]/${Command.Bin}");
      if (box.messagesExists == 0) {
        return 'Zero';
      }
      final fetchResult = await client.fetchMessages(count: 10);
      bin_message = fetchResult;

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
    final token = UserData.userData.token;
    final email = UserData.userData.email;
    final name = UserData.userData.name;
    OauthAuthentication auth = OauthAuthentication(email, token);
    print('discovering settings for  $email...');
    final config = await Discover.discover(email);
    if (config == null) {
      print('Unable to autodiscover settings for $email');
      return DATALOADINGERROR;
    }

    print('connecting to ${config.displayName}.');
    final account =
        MailAccount.fromDiscoveredSettingsWithAuth(name, email, auth, config);
    print('account created');
    final mailClient = MailClient(account, isLogEnabled: true);
    Command.setClient(mailClient);
    try {
      print('inside try');
      await mailClient.connect();
      print('connected');
      final mailboxes = await mailClient.listMailboxes();
      print(mailboxes);
      return DATALOADED;
    } on MailException catch (e) {
      print('High level API failed with $e');
      return DATALOADINGERROR;
    }
  }

  static Future<String> saveToDB(var response) async {
    if (response == DATALOADED) {
      //List of emails is stored to database

      if (inbox_message != null) {
        inboxEmails =
            ListGenerator.mimemessageToEmailList(inbox_message, 'inbox');
        EmailListData.setEmailInboxList(inboxEmails);
        EmailListData.setCurrentEmailList(inboxEmails);
        await StoreToDB.storeInboxMailList(inboxEmails);
      }

      if (draft_message != null) {
        draftEmails =
            ListGenerator.mimemessageToEmailList(draft_message, 'draft');
        EmailListData.setEmailDraftList(draftEmails);
        await StoreToDB.storeDraftMailList(draftEmails);
      }

      if (sent_message != null) {
        sentEmails = ListGenerator.mimemessageToEmailList(sent_message, 'sent');
        EmailListData.setEmailSentList(sentEmails);
        await StoreToDB.storeSentMailList(sentEmails);
      }

      if (bin_message == null) {
        Command.setTrash();
        await fetchBin(Command.Client);
        Command.setBin();
      }

      if (bin_message != null) {
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

  static Future<String> fetchMail(String response,String from) async {
    if (from == 'fetch_all') {
      await fetchInbox(Command.Client);
      await fetchSentMail(Command.Client);
      await fetchDrafts(Command.Client);
      await fetchBin(Command.Client);
    }
    else if(from=='refresh_inbox')
    {
      await fetchInbox(Command.Client);
    }
    response = await saveToDB(response);
    return response;
  }

  static Future<String> getEmailAPI() async {
    var response = await getImapEmailAuthenticate();
    response = await fetchMail(response,'fetch_all');
    new_inbox(Command.Client);
    return response;
  }
}
