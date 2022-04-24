

import 'package:email_client/Database/database_bin_emails_helper.dart';
import 'package:email_client/Database/database_draft_emails_helper.dart';
import 'package:email_client/Database/database_sent_emails_helper.dart';

import '../models/Email.dart';
import '../models/user_data.dart';
import 'database_inbox_emails_helper.dart';
import 'database_user_helper.dart';

class StoreToDB{

  static Future<String> storeInboxMailList(List<Email> emails) async{
    try {
      for (var mail in emails) {
        Map<String, dynamic> json = mail.toJson();
        // print(json);
        int index = await DatabaseInboxEmailsHelper.instance.insert(json);
        print(index);
      }
      return 'SUCCESS';
    }catch(e){
      return e;
    }
  }

  static Future<String> storeDraftMailList(List<Email> emails) async{
    try {
      for (var mail in emails) {
        Map<String, dynamic> json = mail.toJson();
        // print(json);
        int index = await DatabaseDraftEmailsHelper.instance.insert(json);
        print(index);
      }
      return 'SUCCESS';
    }catch(e){
      return e;
    }
  }

  static Future<String> storeSentMailList(List<Email> emails) async{
    try {
      for (var mail in emails) {
        Map<String, dynamic> json = mail.toJson();
        // print(json);
        int index = await DatabaseSentEmailsHelper.instance.insert(json);
        print(index);
      }
      return 'SUCCESS';
    }catch(e){
      return e;
    }
  }

  static Future<String> storeBinMailList(List<Email> emails) async{
    try {
      for (var mail in emails) {
        Map<String, dynamic> json = mail.toJson();
        // print(json);
        int index = await DatabaseBinEmailsHelper.instance.insert(json);
        print(index);
      }
      return 'SUCCESS';
    }catch(e){
      return e;
    }
  }

  static Future<String> storeUser() async{
    try{
      Map<String, dynamic> json = UserData.userData.toJson();
      print(json);
      int index = await DatabaseUserHelper.instance.insertUser(json);
      print("user: $index");
      return 'SUCCESS';
    }catch(e){
      return e;
    }
  }

}