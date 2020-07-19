import 'package:ChatAppWithFireBase/widgets/widget.dart';
import 'package:flutter/material.dart';

class MyCustomBottomAppBarItems extends StatelessWidget {
  final Function(int) onTap;
  final int selectedIndex;

  MyCustomBottomAppBarItems({@required this.selectedIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: GestureDetector(
              onTap: () {
                onTapItem(0);
              },
              child: myCustomBottomAppTab(0, selectedIndex, "ChatRoom", "chat")
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            GestureDetector(
                onTap: () {
                  onTapItem(1);
                },
                child: myCustomBottomAppTab(1, selectedIndex, "Friends", "person")
            ),
            GestureDetector(
                onTap: () {
                  onTapItem(2);
                },
                child: myCustomBottomAppTab(2, selectedIndex, "Program", "person")
            ),
          ],),
        )
      ],
    );
  }

  void onTapItem(int selectIndex) {
    if (onTap != null)
      onTap(selectIndex);
  }
}