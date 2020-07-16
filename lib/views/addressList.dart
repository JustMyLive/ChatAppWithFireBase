import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/helperfunctions.dart';
import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/auth.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/views/addFriends.dart';
import 'package:ChatAppWithFireBase/views/notifications.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {

  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  Stream friendListStream;

  Stream needApproveListStream;

  Widget friendList() {
    return StreamBuilder(
      stream: friendListStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return ListViewItem(userName: snapshot.data.documents[index].data["userName"]);
            }
        ) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharePreference();
    Constants.myDocument = await HelperFunctions.getUserDocumentSharePreference();

    setState(() {});

    dataBaseMethods.getFriendList(Constants.myDocument).then((val) {
      setState(() {
        friendListStream = val;
      });
    });

    dataBaseMethods.getNeedApproveFriendList(Constants.myDocument).then((val) {
      needApproveListStream = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          StreamBuilder(
            stream: needApproveListStream,
            builder: (context, snapshot) {
              return Badge(
                badgeColor: Colors.amberAccent,
                shape: BadgeShape.circle,
                borderRadius: 20,
                position: BadgePosition.topRight(right: 8, top: 10),
                toAnimate: false,
                showBadge: snapshot.hasData && snapshot.data.documents.length > 0,
                badgeContent: Container(),
                child: IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    push(context, Notifications(snapshot.data.documents, Constants.myDocument, Constants.myName));
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              push(context, AddFriends(userName: Constants.myName, userDocumentId: Constants.myDocument));
            },
          ),
        ],
        title: Text(
          'Friends',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(Constants.myName),
            leading: CircleAvatar(
              //backgroundImage: NetworkImage('url'),
            ),
          ),
          SizedBox(
            child: Container(
              margin: EdgeInsets.only(left: 15,right: 15),
              height: 1,
              color: Colors.black,
            ),
          ),
          Expanded(child: friendList()),
        ],
      ),
    );
  }
}

class ListViewItem extends StatelessWidget {

  final String userName;

  ListViewItem({@required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
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
          SizedBox(width: 7,),
          Text(userName, style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),),
        ],
      ),
    );
  }
}






