import 'package:ChatAppWithFireBase/helper/authenticate.dart';
import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/helperfunctions.dart';
import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/views/createChatGroup.dart';
import 'package:ChatAppWithFireBase/views/conversationRoom.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              String userNameOfItem = "";
              List userList = snapshot.data.documents[index].data["users"];
              userList.forEach((element) {
                if (Constants.myName != element)
                  userNameOfItem = element;
              });

              return ChatRoomListItem(
                userNameOfItem,
                snapshot.data.documents[index].data["chatroomId"],
                snapshot.data.documents[index].data["chatroomType"],
                snapshot.data.documents[index].data["chatroomName"],
                snapshot.data.documents[index].data["users"],
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
    dataBaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",
          height: 50,),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              push(context, CreateChatGroup());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.add_circle_outline),
            ),
          ),
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              HelperFunctions.clean();
              replace(context, Authenticate());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomListItem extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String chatType;
  final List<dynamic> userList;
  String chatRoomName;
  ChatRoomListItem(this.userName, this.chatRoomId, this.chatType, this.chatRoomName, this.userList);

  @override
  Widget build(BuildContext context) {
    chatRoomName = this.chatType == "privateType" ? userName : chatRoomName;

    return GestureDetector(
      onTap: () {
        push(context, ConversationScreen(
            chatRoomId,
            chatRoomName,
            chatType: this.chatType == "groupType" ? ChatType.groupChatType : ChatType.privateChatType,
            userList: this.userList,
          ));
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
              child: Text("${chatRoomName.substring(0,1).toUpperCase()}", style: medimTextStyle(),),
            ),
            SizedBox(width: 8,),
            Text(chatRoomName, style: medimTextStyle(),),
          ],
        ),
      ),
    );
  }
}

