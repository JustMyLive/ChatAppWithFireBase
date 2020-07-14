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