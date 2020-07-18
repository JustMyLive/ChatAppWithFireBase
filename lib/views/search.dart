import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/views/conversationRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  QuerySnapshot searchSnapshot;

  initiateSearch(){
    dataBaseMethods.getUserByUsername(searchTextEditingController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return searchListItem(
            searchSnapshot.documents[index].data["name"],
            searchSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }

  Widget searchListItem(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 7),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueAccent,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName, style: medimTextStyle(),),
              Text(userEmail, style: medimTextStyle(),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName : userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Message", style: medimTextStyle(),),
            ),
          ),
        ],
      ),
    );
  }

  createChatroomAndStartConversation({String userName}) async {

    if (userName != Constants.myName) {

      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
        "chatroomType": "privateType",
      };

      await DataBaseMethods().createPrivateChatRoom(chatRoomId, chatRoomMap);

      if (chatRoomId == null) {
        print("Create Room failed, Please check up");
        return;
      }
      push(context, ConversationScreen(chatRoomId, userName));
    } else {
      print("you can send message yourself");
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Search',
          style: TextStyle(
            fontStyle: FontStyle.italic
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(40),
                color: Colors.black12,
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              margin: EdgeInsets.only(left: 15,right: 15,top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "search userName",
                          hintStyle: TextStyle(
                            color: Colors.black54
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF)
                          ]
                        ),
                        borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.all(12),
                      child: Image.asset("assets/images/search_white.png"),
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  var compareResult = a.compareTo(b);
  if (compareResult > 0) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}