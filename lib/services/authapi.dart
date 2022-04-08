import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthApi {

  static final _googleSignIn=GoogleSignIn(scopes: ['https://mail.google.com/']);

  static GoogleSignInAccount USER=_googleSignIn.currentUser;

  static Future<GoogleSignInAccount> signIn() async{
    if(await _googleSignIn.isSignedIn()){
      print('current user');
      print(_googleSignIn.currentUser);
      return _googleSignIn.currentUser;
    }
    print(_googleSignIn);
    return await _googleSignIn.signIn();
  }

  Future<bool> authenticateUser () async{
    final user = await GoogleAuthApi.signIn();
    print(user);
    if (user == null) {
      return false;
    }
    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken;
    // final idToken = auth.idToken;
    USER = user;
    print(email);
    print(token);
    return await GoogleAuthApi.checkStatus();
  }

  static Future<String> getToken() async => (await USER.authentication).accessToken;

  static Future<String> getEmail() async => await USER.email;

  static Future<bool> checkStatus() async => await _googleSignIn.isSignedIn();

  static Future signOut() => _googleSignIn.signOut();

}
