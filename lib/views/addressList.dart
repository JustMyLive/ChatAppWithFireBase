import 'package:ChatAppWithFireBase/helper/constants.dart';
import 'package:ChatAppWithFireBase/helper/helperfunctions.dart';
import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/auth.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/views/addFriends.dart';
import 'package:ChatAppWithFireBase/views/notifications.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:flutter/material.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {

  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  Stream friendListStream;

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
    var aaa = dataBaseMethods.fireBaseTest();

    print("dataBaseMethods.fireBaseTest(): ${aaa}");

    Constants.myName = await HelperFunctions.getUserNameSharePreference();
    Constants.myDocument = await HelperFunctions.getUserDocumentSharePreference();

    dataBaseMethods.getFriendList(Constants.myDocument).then((val) {
      setState(() {
        friendListStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications_active),
                onPressed: () {
                  push(context, Notifications());
                },
              ),
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  push(context, AddFriends());
                },
              ),
            ],
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
            title: Text('MY View'),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(width: 7,),
          Text(userName, style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),),
        ],
      ),
    );
  }
}






