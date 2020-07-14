import 'package:ChatAppWithFireBase/views/addressList.dart';
import 'package:flutter/material.dart';

import 'chatRoom.dart';

class TabBars extends StatefulWidget {
  @override
  _TabBarsState createState() => _TabBarsState();
}

class _TabBarsState extends State<TabBars> {

  final PageController _controller = PageController(initialPage: 0,);
  int _currentIndex = 0;
  int _badge = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(

        controller: _controller,
        onPageChanged: (index){
          print(null);
        },

        physics: NeverScrollableScrollPhysics(),

        children: <Widget>[
          ChatRoom(),
          AddressList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(

        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff145C9E),

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chat),title: Text('ChatRoom')),
          BottomNavigationBarItem(icon: Icon(Icons.person),title: Text('Friends'))
        ],
        currentIndex: _currentIndex,
        onTap: (int index){
          _controller.jumpToPage(index);
          setState(() {
            _badge ++;
            _currentIndex=index;
          });
        },
      ),
    );
  }
}
