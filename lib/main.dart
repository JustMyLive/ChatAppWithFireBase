import 'package:ChatAppWithFireBase/helper/authenticate.dart';
import 'package:ChatAppWithFireBase/views/chatRoom.dart';
import 'package:ChatAppWithFireBase/views/tabbars.dart';
import 'package:flutter/material.dart';

import 'helper/helperfunctions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharePreference().then((value){
      setState(() {
        userIsLoggedIn  = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn != null ? userIsLoggedIn ? TabBars() : Authenticate() : Authenticate()
    );
  }
}