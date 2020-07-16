import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:flutter/material.dart';

class AddFriends extends StatefulWidget {
  @override
  _AddFriendsState createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {

  int count_Test = 0;

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
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: TextField(
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
                    setState(() {
                      count_Test = 5;
                    });
//                    push(context, widget);
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 5,),
          Expanded(
            child: ListView.builder(
              itemCount: count_Test,
              itemBuilder: (context, index) {
                return RequestListItem(userName: "aaaa");
              },
            ),
          ),
        ],
      ),
    );
  }
}

//box of show username that you search
class RequestListItem extends StatelessWidget {

  final String userName;

  RequestListItem({@required this.userName});

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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
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
                print ('ok');
              },
            ),
          ),
        ],
      )
    );
  }
}

