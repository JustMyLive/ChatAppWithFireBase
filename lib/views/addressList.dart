import 'package:flutter/material.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",
        height: 50,
        ),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('MY View'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage('url'),
            ),
          ),
          SizedBox(
            child: Container(
              margin: EdgeInsets.all(10),
              height: 1,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 100,
                itemExtent: 60.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  return FlatButton(
                    child: ListTile(
                      title: Text('Name'),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(''),
                      ),
                    ),
                   onPressed: (){
                      print('ok');
                   },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}


