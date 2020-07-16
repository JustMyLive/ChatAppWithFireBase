import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  final String userDocumentId;
  final String userName;
  List<dynamic> needApproveList;

  Notifications(this.needApproveList, this.userDocumentId, this.userName);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Stream needApproveListStream;

  bool isLoading = false;

  setFriendApprove(bool isApproved, String friendUserName, String otherDocumentId) async {
    setState(() {
      isLoading = true;
    });
    if (await dataBaseMethods.setFriendApprove(
        widget.userDocumentId, otherDocumentId, widget.userName, friendUserName, isApproved)) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    dataBaseMethods.getNeedApproveFriendList(widget.userDocumentId).then((val) {
      needApproveListStream = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body:  Stack(
        children: <Widget>[
          StreamBuilder(
            stream: needApproveListStream,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                widget.needApproveList = snapshot.data.documents;
              return ListView.builder(
                itemCount: widget.needApproveList.length,
                itemBuilder: (context,index) {
                  return RequestsItem(
                    userName: widget.needApproveList[index].data["userName"],
                    documentId: widget.needApproveList[index].data["documentId"],
                    onTap: (isApproved, itemDocumentId, name) {
                      setFriendApprove(isApproved, name, itemDocumentId);
                    },);
                },
              );
            },
          ),
          isLoading ? loadingContainer() : Container(),
        ],
      ),
    );
  }
}

class RequestsItem extends StatelessWidget {

  final String userName;
  final String documentId;
  final Function(bool, String, String) onTap;

  RequestsItem({@required this.userName, @required this.documentId, this.onTap});

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
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(Icons.highlight_off),
                onPressed: (){
                  if (this.onTap != null)
                    onTap(false, this.documentId, this.userName);
                },
              ),
            ),
            Positioned(
              right: 50,
              child: IconButton(
                icon: Icon(Icons.person_add),
                onPressed: (){
                  if (this.onTap != null)
                    onTap(true, this.documentId, this.userName);
                },
              ),
            ),
          ],
        )
    );
  }
}

