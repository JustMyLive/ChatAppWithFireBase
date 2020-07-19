import 'dart:math';

import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/helperfunctions.dart';
import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/widgets/selectUserFromList.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'conversationRoom.dart';

class CreateChatGroup extends StatefulWidget {
  @override
  _CreateChatGroupState createState() => _CreateChatGroupState();
}

class _CreateChatGroupState extends State<CreateChatGroup> {

  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  bool isLoading = false;
  Stream userStream;
  List<Map<String, dynamic>> documentList = [];

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    var aaa = dataBaseMethods.fireBaseTest();

    print("dataBaseMethods.fireBaseTest(): ${aaa}");

    Constants.myName = await HelperFunctions.getUserNameSharePreference();

    dataBaseMethods.getUsers().then((val) {
      setState(() {
        userStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group", style: medimTextStyle(),),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
              onTap: () async {
                List<String> users = [Constants.myName];
                documentList.forEach((element) {
                  if (element["isSelected"])
                    users.add(element["data"].data["name"]);
                });

                if (users.length <3) {
                  FlutterToast(context).showToast(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: defaultBoxDecoration(),
                      child: Text("Please select more than 1 people", style: medimTextStyle(),)),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                  return;
                }

                setState(() {
                  this.isLoading = true;
                });

                var randomNumber = Random().nextInt(10);
                var chatRoomId = await DataBaseMethods().createGroupChatRoom(users, "GroupNameForInit--$randomNumber");
                if (chatRoomId == null) {
                  print("Create Room failed, Please check up");
                  return;
                }

                replace(context, ConversationScreen(
                      chatRoomId, "GroupNameForInit", chatType: ChatType.groupChatType,));
              },
              child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Text("OK")),
            ),
          )
        ],
      ),
      body: SelectUserFromList(
        isLoading: this.isLoading,
        userStream: userStream,
        userName: Constants.myName,
        onTap: (val) {
          this.documentList = val;
        },
      )
    );
  }
}


