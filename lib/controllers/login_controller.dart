import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/login_screen.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInController with ChangeNotifier {
  // Object
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserModel? userModel;
  var data;

  //Function for Google login
  googleLogin() async {
    await _googleSignIn.signIn().then((value) {
      // data = value;
      userModel = UserModel(
          uid: value!.id,
          email: value.email,
          name: value.displayName!,
          photoURL: value.photoUrl);
    });

    // innserting values to our User Model
    // ignore: unnecessary_new

    //call
    notifyListeners();
  }

  //Function for logout
  logout(BuildContext context) async {
    //empty the value after logout
    googleSignInAccount = await _googleSignIn.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));

    //call
    notifyListeners();
  }

  void facebooklogin() {}
}
