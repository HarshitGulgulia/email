import 'package:email_client/models/user.dart';

class UserData {
  static User _user;

  static setUserData(String email, String token, String image, String name) {
    _user = User(email: email, name: name, image: image, token: token);
    print(_user.name);
  }

  static User get userData {
    return _user;
  }
}
