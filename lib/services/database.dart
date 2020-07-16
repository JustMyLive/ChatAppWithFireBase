import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

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

  uploadUserInfo(userMap) async {
    var document = await Firestore.instance.collection("users").document();

    await document.setData(userMap).catchError((e) {
      print(e.toString());
    });

    return document.documentID;
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

  addUserToGroupChatRoom(users, String chatRoomDocumentId) async {

    Map<String, dynamic> chatRoomMap = {
      "users": users,
    };

    bool isSuccessed;
    await Firestore.instance.collection("ChatRoom")
        .document(chatRoomDocumentId)
        .updateData(chatRoomMap)
        .whenComplete(() {
          isSuccessed = true;
        })
        .catchError((e) {
          print(e.toString());
          isSuccessed = false;
        });
    return isSuccessed;
  }

  addConversationMessags(String chatRoomId, messageMap) {
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chatMessages")
        .add(messageMap).catchError((e) {
       print(e.toString());
    });
  }

//  addShareMessags(String chatRoomId, messageMap) {
//    Firestore.instance.collection("ChatRoom")
//        .document(chatRoomId)
//        .collection("chatMessages")
//        .add(messageMap).catchError((e) {
//      print(e.toString());
//    });
//  }

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
        .where("isNeedApprove", isEqualTo: false)
        .snapshots();
  }

  getNeedApproveFriendList(String userDocumentId) async {
    return await Firestore.instance
        .collection("users")
        .document(userDocumentId)
        .collection("friendList")
        .where("isRequestBy", isEqualTo: "other")
        .where("isNeedApprove", isEqualTo: true)
        .snapshots();
  }

  launchFriend(String userDocumentId, String otherDocumentId, String userName, String friendUserName) async {

    Map<String, dynamic> mapOfMine = {
      "userMap": {
        "userName": friendUserName,
        "isRequestBy": "mine",
        "isNeedApprove": true,
        "documentId": otherDocumentId,
      },
      "userDocumentId": userDocumentId,
      "userName": friendUserName,
    };

    Map<String, dynamic> mapOfYour = {
      "userMap": {
        "userName": userName,
        "isRequestBy": "other",
        "isNeedApprove": true,
        "documentId": userDocumentId,
      },
      "userDocumentId": otherDocumentId,
      "userName": userName,
    };

    bool isSucceed = false;
    FutureGroup group = FutureGroup();

    group.add(threadTask(mapOfMine));
    group.add(threadTask(mapOfYour));
    group.close();

    await group.future.then((value) {
      isSucceed = true;
      print("Group success");
    }).catchError((error) {
      print("Group ---- error: $error");
    });

    return isSucceed;
  }



  setFriendApprove(String userDocumentId, String otherDocumentId, String userName ,String friendUserName, bool isApproved) async {
    Map<String, dynamic> mapOfMine = {
      "userMap": {
        "userName": friendUserName,
        "isApproved": isApproved,
        "isRequestBy": "mine",
        "isNeedApprove": false,
        "documentId": otherDocumentId,
      },
      "userDocumentId": userDocumentId,
      "userName": friendUserName,
    };

    Map<String, dynamic> mapOfYour = {
      "userMap": {
        "userName": userName,
        "isApproved": isApproved,
        "isRequestBy": "other",
        "isNeedApprove": false,
        "documentId": userDocumentId,
      },
      "userDocumentId": otherDocumentId,
      "userName": userName,
    };

    bool isSucceed = false;
    FutureGroup group = FutureGroup();

    group.add(threadTask(mapOfMine));
    group.add(threadTask(mapOfYour));
    group.close();

    await group.future.then((value) {
      isSucceed = true;
      print("Group success");
    }).catchError((error) {
      print("Group ---- error: $error");
    });

    return isSucceed;
  }
}

Future<void> threadTask(Map<String, dynamic> map) async {
  await Firestore.instance.collection("users")
      .document(map["userDocumentId"])
      .collection("friendList")
      .document(map["userName"])
      .setData(map["userMap"], merge: true)
      .whenComplete(() {
  }).catchError((e) {
    throw "Fake error";
  });
}