import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/helperfunctions.dart';
import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
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


  Widget userList() {
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        if (documentList.isEmpty) {
          snapshot.data?.documents?.forEach((element) {
            documentList.add({
              "isSelected": false,
              "data": element,
            });
          });
          documentList.removeWhere((element) {
            if (element["data"].data["name"] == Constants.myName)
              return true;
            else
              return false;
          });
        }

        return documentList.isNotEmpty ? ListView.builder(
            itemCount: documentList.length,
            itemBuilder: (context, index) {
              return UserItem(
                  documentList[index]["data"].data["name"].toString(),
                  documentList[index]["isSelected"],
                  onTap: (isSelected, userName) {
                    setState(() {
                      for(int i = 0; i < documentList.length; i++) {
                        if (userName == documentList[i]["data"].data["name"].toString()) {
                          documentList[i]["isSelected"] = isSelected;
                          return;
                        }
                      }
                    });
                  },
              );
            }) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    var aaa = dataBaseMethods.fireBaseTest();

    print("dataBaseMethods.fireBaseTest(): ${aaa}");

    Constants.myName = await HelperFunctions.getUserNameSharePreference();

    dataBaseMethods.getUsers(Constants.myName).then((val) {
      setState(() {
        userStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group", style: simpleTextStyle(),),
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
                      child: Text("Please select more than 1 people", style: simpleTextStyle(),)),
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2),
                  );
                  return;
                }

                setState(() {
                  this.isLoading = true;
                });

                var chatRoomId = await DataBaseMethods().createGroupChatRoom(users, "GroupNameForInit");
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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Container(
                  height: 40,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: documentList.length,
                      itemBuilder: (context, index) {
                        if (documentList[index]["isSelected"])
                          return AlreadyAddUserItem(documentList[index]["data"].data["name"]);
                        else
                          return Container();
                      }
                  ),
                ),
              ),
              Expanded(child: userList())
            ],
          ),
          isLoading ? loadingContainer() : Container(),
        ],
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  final String userName;
  final Function(bool, String) onTap;
  final bool isSelected;

  UserItem(this.userName, this.isSelected, {this.onTap});



  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(!isSelected, userName);
        }
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center ,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}", style: medimTextStyle(),),
            ),
            SizedBox(width: 8,),
            Expanded(
                child: Text(userName, style: medimTextStyle(),)),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: Colors.white,),
//            Icon(Icons.check_circle, color: Colors.white,),
          ],
        ),
      ),
    );
  }
}


class AlreadyAddUserItem extends StatelessWidget {
  final String userName;
  AlreadyAddUserItem(this.userName);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 40,
      width: 40,
      alignment: Alignment.center ,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Text("${userName.substring(0,1).toUpperCase()}", style: medimTextStyle(),),
    );
  }
}

