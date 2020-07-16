import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddFriends extends StatefulWidget {
  final String userName;
  final String userDocumentId;

  AddFriends({@required this.userName, @required this.userDocumentId});

  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {

  TextEditingController searchTextEditingController = new TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  QuerySnapshot searchSnapshot;
  bool isLoading = false;
  String otherDocumentId;

  initiateSearch(){
    setState(() {
      isLoading = true;
    });
    dataBaseMethods.getUserByUsername(searchTextEditingController.text).then((val) {
      setState(() {
        isLoading = false;
        searchSnapshot = val;
      });
    });
  }

  addFriendUser(String userName) async {
    if (widget.userName != userName) {
      setState(() {
        isLoading = true;
      });
      bool isSucceed = await dataBaseMethods.launchFriend(
          widget.userDocumentId,
          otherDocumentId,
          widget.userName,
          userName);
      if (isSucceed) {
         Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return RequestListItem(
            userName: searchSnapshot.documents[index].data["name"],
            onTap: (val) {
              otherDocumentId = searchSnapshot.documents[index].documentID;
              addFriendUser(val);
            },
          );
        }) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Friends',
          style: TextStyle(
            fontStyle: FontStyle.italic
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: TextField(
                      controller: searchTextEditingController,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'email',
                          prefixIcon: Icon(Icons.person)
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 5,
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        initiateSearch();
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 5,),
              Expanded(
                child: searchList()
              ),
            ],
          ),
          isLoading ? loadingContainer() : Container(),
        ],
      ),
    );
  }
}

//box of show username that you search
class RequestListItem extends StatelessWidget {

  final String userName;
  final Function(String) onTap;

  RequestListItem({@required this.userName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 15, left: 15, right: 10),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
                child: Text("${userName.substring(0,1).toUpperCase()}", style: medimTextStyle(),),
              ),
              SizedBox(width: 7,),
              Text(userName, style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),),
            ],
          ),
          Positioned(
            right: 10,
            child: IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: (){
                if (this.onTap != null) {
                  this.onTap(userName);
                }
              },
            ),
          ),
        ],
      )
    );
  }
}


