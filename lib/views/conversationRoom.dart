import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/views/programDetail.dart';
import 'package:ChatAppWithFireBase/views/removeUserToGroup.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyhub/flutter_easy_hub.dart';

import 'addUserToGroup.dart';

enum ChatType {
  privateChatType,
  groupChatType
}

class ConversationScreen extends StatefulWidget {
  final ChatType chatType;
  final String chatRoomId;
  final String chatRoomName;
  List<dynamic> userList;

  ConversationScreen(this.chatRoomId, this.chatRoomName, {this.chatType = ChatType.privateChatType, this.userList});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessagesStream;

  Widget ChatMessageList() {
    return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, snapshot) {
          return snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                if (snapshot.data.documents[index].data["messageType"] == "program")
                  return MessageShareItem(
                    snapshot.data.documents[index].data["messageText"],
                    snapshot.data.documents[index].data["sendBy"] == Constants.myName,
                    snapshot.data.documents[index].data["sendBy"],
                    snapshot.data.documents[index].data["photoUrl"],
                  );
                else
                return MessageTitle(
                  snapshot.data.documents[index].data["message"],
                  snapshot.data.documents[index].data["sendBy"] == Constants.myName,
                  snapshot.data.documents[index].data["sendBy"],
                );
              }) : Container();
        }
    );
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      Map<String, dynamic> roomMessageMap = {
        "lastMessage": messageController.text,
        "lastMessageTime": DateTime.now().millisecondsSinceEpoch
      };
      messageController.text = "";

      bool isSucceed = await dataBaseMethods.addConversationMessags(widget.chatRoomId, messageMap, roomMessageMap);

    }
  }

  @override
  void initState() {
    dataBaseMethods.getConversationMessags(widget.chatRoomId).then((val) {
       setState(() {
         chatMessagesStream = val;
       });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomName ?? ""),
        actions: <Widget>[
          widget.chatType == ChatType.groupChatType ?
          IconButton(icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                push(context, AddUserToGroup(
                  chatRoomDocumentId: widget.chatRoomId,
                  alreadyExistsUserList: widget.userList,
                  userListCallBack: (val) {
                    widget.userList = val;
                  },));
              }) : Container(),
          widget.chatType == ChatType.groupChatType ?
          IconButton(icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                push(context, RemoveUserToGroup(
                  chatRoomDocumentId: widget.chatRoomId,
                  alreadyExistsUserList: widget.userList,
                  userListCallBack: (val) {
                    widget.userList = val;
                  },));
              }) : Container(),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ChatMessageList(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0xff145C9E),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          constraints: BoxConstraints(
                              maxHeight: 194.0,
//                              minHeight: 48.0,
                          ),
                          child: TextField(
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            controller: messageController,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            decoration: InputDecoration(
                                hintText: "please print...",
                                hintStyle: TextStyle(
                                    color: Colors.white54
                                ),
                                border: InputBorder.none
                            ),
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                        child: Image.asset("assets/images/send.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTitle extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final userName;
  MessageTitle(this.message, this.isSendByMe, this.userName);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          isSendByMe ? loadingContainerOfConversation(isSendByMe) : userHeaderImage(userName),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: isSendByMe ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23)
                  ) : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23)),
                  color: isSendByMe ? Colors.blue : Colors.white,
              ),
              child: Text(message, style: TextStyle(
                color: isSendByMe ? Colors.white : Colors.black54,
                fontSize: 15
              ),),
            ),
          ),
          isSendByMe ? userHeaderImage(userName) : loadingContainerOfConversation(isSendByMe)
        ],
      ),
    );
  }


}

class MessageShareItem extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String userName;
  final String photoUrl;
  MessageShareItem(this.message, this.isSendByMe, this.userName, this.photoUrl);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 10),
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          isSendByMe ? loadingContainerOfConversation(isSendByMe) : userHeaderImage(userName),
          Flexible(
            child: ClipRRect(
              borderRadius: isSendByMe ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23)
              ) : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
              child: GestureDetector(
                onTap: () {
                  push(context, ProgramDetail());
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(width: 120, height: 120,
                        child: CachedNetworkImage(
                          imageUrl: photoUrl,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => imageLoading(),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Text(message ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isSendByMe ? userHeaderImage(userName) : loadingContainerOfConversation(isSendByMe)
        ],
      ),
    );
  }
}

