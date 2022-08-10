import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Screens/login_screen.dart';
import 'package:flutter_application_1/Screens/qoute.dart';
import 'package:flutter_application_1/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
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
                      child:
                          Image.asset("assets/logo.png", fit: BoxFit.contain),
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
                    ActionChip(
                        label: const Text("Genrate Qoute"),
                        onPressed: () {
                          var quote;
                          var author;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => QouteScreen(
                                    quote1: quote,
                                    author1: author,
                                  )));
                        }),
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

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
