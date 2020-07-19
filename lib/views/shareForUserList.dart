import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ShareForUserList extends StatefulWidget {
  final String programId;
  final String programTitle;
  final String programImage;

  ShareForUserList({this.programId, this.programImage, this.programTitle});

  @override
  _ShareForUserListState createState() => _ShareForUserListState();
}

class _ShareForUserListState extends State<ShareForUserList> {

  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Stream userListStream;
  Stream groupListStream;

  bool isLoading = false;

  @override
  void initState() {
    getListData();
    super.initState();
  }

  getListData() {
    dataBaseMethods.getUsers().then((val) {
      setState(() {
        userListStream = val;
      });
    });

    dataBaseMethods.getGroups(Constants.myName).then((val) {
      setState(() {
        groupListStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      body: (userListStream != null && groupListStream != null) ? Stack(
        children: <Widget>[
          StreamBuilder(
          stream: Rx.combineLatest2(userListStream, groupListStream, (userList, groupList)
            => ShareList(userList, groupList)),
          builder: (context, snapshot) {
            List documentList = [];
            snapshot.data.groupList?.documents?.forEach((val) {
              documentList.add({
                "name": val.data["chatroomName"],
                "documentId": val.data["chatroomId"],
                "type": "groupType"
              });
            });
            snapshot.data.userList?.documents?.forEach((val) {
              documentList.add({
                "name": val.data["name"],
                "documentId": getChatRoomId(val.data["name"], Constants.myName),
                "type": "privateType",
                "users": [val.data["name"], Constants.myName]
              });
            });
            documentList?.removeWhere((element) {
              if (element["name"] == Constants.myName)
                return true;
              else
                return false;
            });
            return ListView.builder(
              itemCount: documentList.length,
              itemBuilder: (context, index) {
                return UserItem(documentList[index]["name"],
                  onTap: (val)  {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      desc: 'You will Share message to $val',
                      title: 'Share',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        Map<String, dynamic> messageMap = {
                          "programId": widget.programId,
                          "message": "Share Message",
                          "messageText": widget.programTitle,
                          "messageType": "program",
                          "photoUrl": widget.programImage,
                          "sendBy": Constants.myName,
                          "time": DateTime.now().millisecondsSinceEpoch
                        };
                        Map<String, dynamic> roomMessageMap = {
                          "lastMessage": "Share Message",
                          "lastMessageTime": DateTime.now().millisecondsSinceEpoch,
                        };
                        if (documentList[index]["type"] == "privateType") {
                          roomMessageMap["chatroomId"] = documentList[index]["documentId"];
                          roomMessageMap["users"] = documentList[index]["users"];
                          roomMessageMap["chatroomType"] = documentList[index]["type"];
                        }
                        setState(() {
                          isLoading = true;
                        });
                        bool isSucceed = await dataBaseMethods.addConversationMessags(
                            documentList[index]["documentId"],
                            messageMap,
                            roomMessageMap);
                        if (isSucceed) {
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    )..show();
                  },);
              });
          }),
          isLoading ? loadingContainer() : Container(),
        ],
      )  : Container(),
    );
  }
}


class UserItem extends StatelessWidget {
  final String userName;
  final Function(String) onTap;

  UserItem(this.userName, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(userName);
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
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
              ],
            ),
          ),
          Container(
            height: 1,)
        ],
      ),
    );
  }
}

class ShareList {
  final QuerySnapshot userList;
  final QuerySnapshot groupList;

  ShareList(this.userList, this.groupList);
}



