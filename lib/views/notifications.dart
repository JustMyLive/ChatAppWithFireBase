import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  int count_Test = 5;

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
      body: ListView.builder(
          itemCount: count_Test,
          itemBuilder: (context,index) {
            return Requests(userName: 'aaa',);
          },
      )
    );
  }
}

class Requests extends StatelessWidget {

  final String userName;

  Requests ({@required this.userName});

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
              right: 0,
              child: IconButton(
                icon: Icon(Icons.highlight_off),
                onPressed: (){
                  print ('refuse');
                },
              ),
            ),
            Positioned(
              right: 50,
              child: IconButton(
                icon: Icon(Icons.person_add),
                onPressed: (){
                  print ('recive');
                },
              ),
            ),
          ],
        )
    );
  }
}

