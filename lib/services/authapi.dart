import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';

///Performs operations like Google sign-in, check sign-in status, sign-out and generates refresh token
class GoogleAuthApi {

  static final _googleSignIn=GoogleSignIn(scopes: ['https://mail.google.com/']);

  static GoogleSignInAccount USER=_googleSignIn.currentUser;

  static String REFRESH_TOKEN;

  static Future<GoogleSignInAccount> signIn() async{
    if(await _googleSignIn.isSignedIn()){
      print('current user');
      print(_googleSignIn.currentUser);
      return _googleSignIn.currentUser;
    }
    print(_googleSignIn);
    return await _googleSignIn.signIn();
  }

  static Future<bool> generateRefreshToken() async {
    print("Token Refresh");
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signInSilently();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    REFRESH_TOKEN=googleSignInAuthentication.accessToken;
    if(REFRESH_TOKEN!=null) {
      return true;
    }
    else{
      return false;
    }
  }

  ///User authentication returns status if sign-in is successful or not
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

  static String getRefreshToken() => REFRESH_TOKEN;

  static Future<String> getToken() async => (await USER.authentication).accessToken;

  static Future<String> getEmail() async => await USER.email;

  static Future<bool> checkStatus() async => await _googleSignIn.isSignedIn();

  static Future signOut() => _googleSignIn.signOut();

}
