import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {

  fireBaseTest() {
    return Firestore.instance.collection("users").document();
  }

  getUserByUsername(String username) async {
    return await Firestore.instance.collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance.collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users")
        .add(userMap).catchError((e) {
          print(e.toString());
    });
  }

  createPrivateChatRoom(String chatroomId, chatRoomMap) async {
    await Firestore.instance.collection("ChatRoom")
        .document(chatroomId)
        .setData(chatRoomMap, merge: true).catchError((e) {
      print(e.toString());
    });
  }

  createGroupChatRoom(users, String chatRoomName) async {
    var document = Firestore.instance.collection("ChatRoom").document();

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": document.documentID,
      "chatroomType": "groupType",
      "chatroomName": chatRoomName
    };
    await document.setData(chatRoomMap).catchError((e) {
          print(e.toString());
          return;
    });

    return document.documentID;
  }

  addConversationMessags(String chatRoomId, messageMap) {
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chatMessages")
        .add(messageMap).catchError((e) {
       print(e.toString());
    });
  }

  getConversationMessags(String chatRoomId) async {
    return await Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chatMessages")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  getUsers(String userName) async {
    return await Firestore.instance
        .collection("users")
        .snapshots();
  }

  getFriendList(String userDocumentId) async {
    return await Firestore.instance
        .collection("users")
        .document(userDocumentId)
        .collection("friendList")
        .where("isApproved", isEqualTo: true)
        .where("isDeleted", isEqualTo: false)
        .snapshots();
  }

  getUnApproveFriendList(String userDocumentId) async {
    return await Firestore.instance
        .collection("users")
        .document(userDocumentId)
        .collection("friendList")
        .where("isApproved", isEqualTo: null)
        .where("isDeleted", isEqualTo: null)
        .snapshots();
  }

  launchFriend(String userDocumentId, String friendUserName) async {
    Map<String, dynamic> friendListMap = {
      "userName": friendUserName,
    };

    await Firestore.instance
        .collection("users")
        .document(userDocumentId)
        .collection("friendList")
        .document(friendUserName)
        .setData(friendListMap, merge: true)
        .whenComplete(() => () {
      return true;
    }).catchError((e) {
      return false;
    });
  }

  setFriendApprove(String userDocumentId, String friendUserName, bool isApproved) async {
    Map<String, dynamic> friendListMap = {
      "userName": friendUserName,
      "isApproved": isApproved,
      "isDeleted": false,
    };

    await Firestore.instance
        .collection("users")
        .document(userDocumentId)
        .collection("friendList")
        .document(friendUserName)
        .setData(friendListMap, merge: true)
        .whenComplete(() => () {
      return true;
    }).catchError((e) {
      return false;
    });
  }
}