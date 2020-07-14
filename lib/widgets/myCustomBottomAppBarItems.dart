import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:flutter/material.dart';

class MyCustomBottomAppBarItems extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;

  MyCustomBottomAppBarItems({@required this.selectedIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              onTapItem(0);
            },
            child: myCustomBottomAppTab(0, selectedIndex, "ChatRoom", "chat")
        ),
        GestureDetector(
            onTap: () {
              onTapItem(1);
            },
            child: myCustomBottomAppTab(1, selectedIndex, "Friends", "person")
        ),
      ],
    );
  }

  void onTapItem(int selectIndex) {
    if (onTap != null)
      onTap(selectIndex);
  }
}