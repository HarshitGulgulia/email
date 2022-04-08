import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthApi {

  static final _googleSignIn=GoogleSignIn(scopes: ['https://mail.google.com/']);

  static Future<GoogleSignInAccount> signIn() async{
    if(await _googleSignIn.isSignedIn()){
      print('current user');
      return _googleSignIn.currentUser;
    }
    return await _googleSignIn.signIn();
  }


  static Future<bool> checkStatus() async => await _googleSignIn.isSignedIn();

  static Future signOut() => _googleSignIn.signOut();

}
