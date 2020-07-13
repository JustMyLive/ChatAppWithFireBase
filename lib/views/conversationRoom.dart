import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ChatType {
  privateChatType,
  groupChatType
}

class ConversationScreen extends StatefulWidget {
  final ChatType chatType;
  final String chatRoomId;
  final String chatRoomName;
  ConversationScreen(this.chatRoomId, this.chatRoomName, {this.chatType = ChatType.privateChatType});

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
                return MessageTitle(
                  snapshot.data.documents[index].data["message"],
                  snapshot.data.documents[index].data["sendBy"] == Constants.myName,
                  snapshot.data.documents[index].data["sendBy"],
                );
              }) : Container();
        }
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      dataBaseMethods.addConversationMessags(widget.chatRoomId, messageMap);
      messageController.text = "";
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

              }) : Container(),
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: "search userName",
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                              border: InputBorder.none
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
        children: <Widget>[
          isSendByMe ? SizedBox(width: 80,) : userHeaderImage(),
          Expanded(
            child: Container(
              alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
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
                    gradient: LinearGradient(
                      colors: isSendByMe ? [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ]
                          : [
                        const Color(0x1AFFFFFF),
                        const Color(0x1AFFFFFF)
                      ],
                    )
                ),
                child: Text(message, style: simpleTextStyle(),),
              ),
            ),
          ),
          isSendByMe ? userHeaderImage() : SizedBox(width: 80,),
        ],
      ),
    );
  }

  Widget userHeaderImage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
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
