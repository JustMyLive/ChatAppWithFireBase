import 'package:flutter/material.dart';

push(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(
      builder: (context) => widget
  ));
}

replace(BuildContext context, Widget widget) {
  Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => widget
  ));
}

getChatRoomId(String a, String b) {
  var compareResult = a.compareTo(b);
  if (compareResult > 0) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}