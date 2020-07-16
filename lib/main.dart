import 'package:ChatAppWithFireBase/helper/authenticate.dart';
import 'package:ChatAppWithFireBase/views/chatRoom.dart';
import 'package:ChatAppWithFireBase/views/signIn.dart';
import 'package:ChatAppWithFireBase/views/tabbars.dart';
import 'package:flutter/material.dart';

import 'helper/helperfunctions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'ChatWithFireStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color.fromRGBO(235, 235, 235, 1),
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn != null ? userIsLoggedIn ? TabBars() : SignIn() : SignIn()
    );
  }
}