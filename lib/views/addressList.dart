import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",
        height: 50,
        ),
      ),
      body: ListView.builder(
        itemCount: 100,
        itemExtent: 50,
        itemBuilder: (BuildContext context,int index){
          return Container(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(''),
              ),
              title: Text(
                'User',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            ),
          );
        },
      ),
    );
  }
}



