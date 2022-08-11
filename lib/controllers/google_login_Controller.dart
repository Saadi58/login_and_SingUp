import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController with ChangeNotifier {
  // Object
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;

  //Function for login
  login() async {
    this.googleSignInAccount = await _googleSignIn.signIn();

    //call
    notifyListeners();
  }

  //Function for logout
  logout() async {
    //empty the value after logout
    this.googleSignInAccount = await _googleSignIn.signOut();

    //call
    notifyListeners();
  }
}
