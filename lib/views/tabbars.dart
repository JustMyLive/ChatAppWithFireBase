import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/views/addressList.dart';
import 'package:ChatAppWithFireBase/views/search.dart';
import 'package:ChatAppWithFireBase/widgets/myCustomBottomAppBarItems.dart';
import 'package:flutter/material.dart';

import 'chatRoom.dart';

class TabBars extends StatefulWidget {
  @override
  _TabBarsState createState() => _TabBarsState();
}

class _TabBarsState extends State<TabBars> {

  final PageController _controller = PageController(initialPage: 0,);

  int _currentIndex = 0;

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(52, 101, 165, 1),
        child: Icon(Icons.search),
        elevation: 0,
        onPressed: () {
          push(context, SearchScreen());
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(52, 101, 165, 1),
        child: SizedBox(
          height: 55,
          child: MyCustomBottomAppBarItems(
            selectedIndex: _currentIndex,
            onTap: (index) {
              _controller.jumpToPage(index);
              setState(() {
                _currentIndex = index;
              });
            },
          )
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}