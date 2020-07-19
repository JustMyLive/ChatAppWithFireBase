import 'package:flutter/material.dart';

class ProgramDetail extends StatefulWidget {
  @override
  _ProgramDetailState createState() => _ProgramDetailState();
}

class _ProgramDetailState extends State<ProgramDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Program Detail"),
      ),
      body: Container(
        child: Center(
          child: Text("Program Detail Text Show!!!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.black54
            ),),
        ),
      ),
    );
  }
}
