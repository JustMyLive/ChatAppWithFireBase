import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/helperfunctions.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/widgets/selectUserFromList.dart';
import 'package:flutter/material.dart';

class AddUserToGroup extends StatefulWidget {
  final String chatRoomDocumentId;
  final List<dynamic> alreadyExistsUserList;
  final Function(List<dynamic>) userListCallBack;

  AddUserToGroup({@required this.chatRoomDocumentId, this.alreadyExistsUserList, @required this.userListCallBack});

  @override
  _AddUserToGroupState createState() => _AddUserToGroupState();
}

class _AddUserToGroupState extends State<AddUserToGroup> {

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
        title: Text("AddUser"),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              List<dynamic> users = [Constants.myName];
              documentList.forEach((element) {
                if (element["isSelected"])
                  users.add(element["data"].data["name"]);
              });

              if (users.length <1) {
                return;
              }
              users.addAll(widget.alreadyExistsUserList);

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
              child: Center(child: Text("OK", style: TextStyle(fontSize: 17),)),
            ),
          )
        ],
      ),
      body: SelectUserFromList(
        isLoading: this.isLoading,
        userStream: userStream,
        userName: Constants.myName,
        alreadyExistsUserList: widget.alreadyExistsUserList,
        selectUserType: SelectUserType.selectUserAboutAddUserType,
        onTap: (val) {
          this.documentList = val;
        },
      ),
    );
  }
}
