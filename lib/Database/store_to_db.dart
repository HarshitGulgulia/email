

import 'package:email_client/models/user.dart';

import '../models/Email.dart';
import '../models/user_data.dart';
import 'database_emails_helper.dart';
import 'database_user_helper.dart';

class StoreToDB{

  static Future<String> storeMailList(List<Email> emails) async{
    try {
      for (var mail in emails) {
        Map<String, dynamic> json = mail.toJson();
        // print(json);
        int index = await DatabaseEmailsHelper.instance.insert(json);
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