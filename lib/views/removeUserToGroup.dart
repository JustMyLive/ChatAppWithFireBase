import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/helperfunctions.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/widgets/selectUserFromList.dart';
import 'package:flutter/material.dart';

class RemoveUserToGroup extends StatefulWidget {
  final String chatRoomDocumentId;
  final List<dynamic> alreadyExistsUserList;
  final Function(List<dynamic>) userListCallBack;

  RemoveUserToGroup({@required this.chatRoomDocumentId, this.alreadyExistsUserList, @required this.userListCallBack});

  @override
  _RemoveUserToGroupState createState() => _RemoveUserToGroupState();
}

class _RemoveUserToGroupState extends State<RemoveUserToGroup> {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  final ValueNotifier<int> selectCount = ValueNotifier<int>(0);

  bool isLoading = false;
  Stream userStream;
  List<Map<String, dynamic>> documentList = [];

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharePreference();

    widget.alreadyExistsUserList.forEach((element) {
      if (element != Constants.myName)
      documentList.add({
        "isSelected": false,
        "data": element,
      });
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RemoveUser"),
        actions: <Widget>[
          ValueListenableBuilder(
            valueListenable: selectCount,
            builder: (BuildContext context, int value, Widget child) {
              return child;
            },
            child: GestureDetector(
              onTap: () async {
                List<dynamic> users = [Constants.myName];
                List<dynamic> deleteUsers = [];
                documentList.forEach((element) {
                  if (!element["isSelected"])
                    users.add(element["data"]);
                  else
                    deleteUsers.add(element);
                });

                if (deleteUsers.length <1) {
                  return;
                }

                setState(() {
                  this.isLoading = true;
                });

                bool isSuccessed = await DataBaseMethods().addUserToGroupChatRoom(users, widget.chatRoomDocumentId);
                if (isSuccessed) {
                  widget.userListCallBack(users);
                  Navigator.pop(context);
                }
                else
                  return;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(child: Text("OK",
                  style: TextStyle(
                      fontSize: 17,
                      color: selectCount.value > 0 ? Colors.white : Colors.grey
                  ),)),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: documentList.length,
          itemBuilder: (context, index) {
            return UserItem(
              documentList[index]["data"],
              documentList[index]["isSelected"],
              onTap: (isSelected, userName) {
                setState(() {
                  for(int i = 0; i < documentList.length; i++) {
                    if (userName == documentList[i]["data"]) {
                      documentList[i]["isSelected"] = isSelected;
                      int count = 0;
                      documentList.forEach((element) {
                        if (element["isSelected"])
                          count ++;
                      });
                      selectCount.value = count;
                      return;
                    }
                  }
                });
              },
            );
          }),
    );
  }
}
