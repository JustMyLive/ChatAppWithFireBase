import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:flutter/material.dart';

enum SelectUserType {
  selectUserAboutCreateGroupType,
  selectUserAboutAddUserType,
}

class SelectUserFromList extends StatefulWidget {
  final bool isLoading;
  final Stream userStream;
  final String userName;
  final Function(dynamic) onTap;
  final List<dynamic> alreadyExistsUserList;
  final SelectUserType selectUserType;

  SelectUserFromList({@required this.isLoading, @required this.userStream, @required this.userName,
    this.alreadyExistsUserList,
    this.selectUserType = SelectUserType.selectUserAboutCreateGroupType,
    this.onTap});

  @override
  _SelectUserFromListState createState() => _SelectUserFromListState();
}

class _SelectUserFromListState extends State<SelectUserFromList> {
  List<Map<String, dynamic>> documentList = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              color: Colors.black12,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Container(
                height: 40,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: documentList.length,
                    itemBuilder: (context, index) {
                      if (documentList[index]["isSelected"])
                        return AlreadyAddUserItem(documentList[index]["data"].data["name"]);
                      else
                        return Container();
                    }
                ),
              ),
            ),
            Expanded(child: userList())
          ],
        ),
        widget.isLoading ? loadingContainer() : Container(),
      ],
    );
  }

  Widget userList() {
    return StreamBuilder(
      stream: widget.userStream,
      builder: (context, snapshot) {
        if (documentList.isEmpty) {
          snapshot.data?.documents?.forEach((element) {
            documentList.add({
              "isSelected": false,
              "data": element,
            });
          });
          fixDocumentList();
        }

        return documentList.isNotEmpty ? ListView.builder(
            itemCount: documentList.length,
            itemBuilder: (context, index) {
              return UserItem(
                documentList[index]["data"].data["name"].toString(),
                documentList[index]["isSelected"],
                onTap: (isSelected, userName) {
                  setState(() {
                    for(int i = 0; i < documentList.length; i++) {
                      if (userName == documentList[i]["data"].data["name"].toString()) {
                        documentList[i]["isSelected"] = isSelected;
                        if (widget.onTap != null) {
                          widget.onTap(documentList);
                        }
                        return;
                      }
                    }
                  });
                },
              );
            }) : Container();
      },
    );
  }

  fixDocumentList() {
    switch(widget.selectUserType) {
      case SelectUserType.selectUserAboutCreateGroupType:
        documentList.removeWhere((element) {
          if (element["data"].data["name"] == widget.userName)
            return true;
          else
            return false;
        });
        break;
      case SelectUserType.selectUserAboutAddUserType:
        documentList.removeWhere((element) {
          bool isAlreadyExist = false;
          widget.alreadyExistsUserList.forEach((val) {
            if (element["data"].data["name"] == val) {
              isAlreadyExist = true;
              return;
            }
          });

          return isAlreadyExist;
        });
        break;
    }
  }
}

class UserItem extends StatelessWidget {
  final String userName;
  final Function(bool, String) onTap;
  final bool isSelected;

  UserItem(this.userName, this.isSelected, {this.onTap});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(!isSelected, userName);
        }
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
              child: Text("${userName.substring(0,1).toUpperCase()}", style: medimTextStyle(),),
            ),
            SizedBox(width: 8,),
            Expanded(
                child: Text(userName, style: medimTextStyle(),)),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: Colors.white,),
//            Icon(Icons.check_circle, color: Colors.white,),
          ],
        ),
      ),
    );
  }
}

class AlreadyAddUserItem extends StatelessWidget {
  final String userName;
  AlreadyAddUserItem(this.userName);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(right: 10),
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