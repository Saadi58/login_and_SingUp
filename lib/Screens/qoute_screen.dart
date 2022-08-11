import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class QouteScreen extends StatefulWidget {
  String? quote1;
  Object? author1;

  QouteScreen({Key? key, this.quote1, this.author1}) : super(key: key);

  @override
  State<QouteScreen> createState() => _QouteScreenState();
}

class _QouteScreenState extends State<QouteScreen> {
  String? quote;
  String? author;
  @override
  Widget build(BuildContext context) {
    //Qoute Button
    final qouteButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.indigo,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          var url = Uri.parse(
              'https://goquotes-api.herokuapp.com/api/v1/random?count=1');
          var response = await http.get(url);
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
          var data = jsonDecode(response.body);
          setState(() {
            quote = data["quotes"][0]["text"];
            author = data["quotes"][0]["author"];
          });
        },
        child: const Text(
          "Generate Qoute",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Qoutes For You!",
          style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left_outlined,
            color: Colors.indigo,
          ),
          onPressed: () {
            //passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Image.asset("assets/logo.png", fit: BoxFit.contain),
              ),
              const SizedBox(height: 25),
              quote != null
                  ? Text(
                      quote.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  : Container(),
              const SizedBox(height: 25),
              author != null
                  ? Text(
                      author.toString(),
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  : Container(),
              const SizedBox(height: 25),
              qouteButton,
            ],
          ),
        ),
      ),
    );
  }
}
