import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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

    dataBaseMethods.getGroups().then((val) {
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
            var documentList = snapshot.data?.documents;
            documentList?.removeWhere((element) {
              if (element.data["name"] == Constants.myName)
                return true;
              else
                return false;
            });
            return ListView.builder(
              itemCount: documentList.length,
              itemBuilder: (context, index) {
                return UserItem(documentList[index].data["name"],
                  onTap: (val) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      desc: 'You will Share message to $val',
                      title: 'Share',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        //dataBaseMethods.addConversationMessags(chatRoomId, messageMap, roomMessageMap)
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
  final List<dynamic> userList;
  final List<dynamic> groupList;

  ShareList(this.userList, this.groupList);
}



