

import 'package:email_client/Database/database_user_helper.dart';

///Email data received is stored in this class
class User {
  final String image, name, email, token;

  User({
    this.image,
    this.name,
    this.email,
    this.token
  });

  Map<String, dynamic> toJson() =>
      {
        DatabaseUserHelper.columnName : name,
        DatabaseUserHelper.columnImage: image,
        DatabaseUserHelper.columnEmail : email,
        DatabaseUserHelper.columnToken: token,
      };

}