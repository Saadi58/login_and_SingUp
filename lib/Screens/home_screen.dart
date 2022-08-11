import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/login_screen.dart';
import 'package:flutter_application_1/Screens/qoute_screen.dart';
import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  int num;
  HomeScreen({
    Key? key,
    this.num = 0,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? loggedInUser;

  @override
  void initState() {
    super.initState();
    if (widget.num != 0) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        UserModel user = UserModel(
          uid: value.id,
          email: value['email'],
          name: value['firstName'] + ' ' + value['secondName'],
        );
        loggedInUser = user;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Generate Qoute Button
    final GenerateqouteButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.indigo,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          var quote;
          var author;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QouteScreen(
                    quote1: quote,
                    author1: author,
                  )));
        },
        child: const Text(
          "Go To Generate Qoute",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return widget.num == 0
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Welcome",
                style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 25),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        // height: 100,
                        // child:
                        //     Image.asset("assets/logo.png", fit: BoxFit.contain),
                        ),
                    SizedBox(
                      height: 100,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          Provider.of<LogInController>(context, listen: true)
                              .userModel!
                              .photoURL!,
                        ),
                        maxRadius: 60,
                      ),
                    ),
                    const Text(
                      "Welcome Back",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      Provider.of<LogInController>(context, listen: true)
                          .userModel!
                          .name,
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    Text(
                      Provider.of<LogInController>(context, listen: true)
                          .userModel!
                          .email,
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GenerateqouteButton,
                    const SizedBox(
                      height: 15,
                    ),
                    ActionChip(
                        label: const Text("LogOut"),
                        onPressed: () {
                          Provider.of<LogInController>(context, listen: false)
                              .logout(context)
                              .then((_) {
                            Provider.of<LogInController>(context, listen: false)
                                .userModel = null;
                          });
                        }),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "Welcome",
                style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 25),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: loggedInUser == null
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 180,
                            child: Image.asset("assets/logo.png",
                                fit: BoxFit.contain),
                          ),
                          const Text(
                            "Welcome Back",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            loggedInUser!.name,
                            style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          Text(
                            loggedInUser!.email,
                            style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GenerateqouteButton,
                          const SizedBox(
                            height: 15,
                          ),
                          ActionChip(
                              label: const Text("LogOut"),
                              onPressed: () {
                                logout(context);
                              }),
                        ],
                      ),
                    ),
                  ),
          );
  }

  final _googleSignIn = GoogleSignIn();
  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
