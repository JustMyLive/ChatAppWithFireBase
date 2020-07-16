import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/logo.png",
      height: 50,),
  );
}

InputDecoration textFiledInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: TextStyle(
        color: Colors.black54,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
      ),
  );
}

TextStyle tabBarSelectedTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 13,
  );
}

TextStyle tabBarUnSelectedTextStyle() {
  return TextStyle(
    color: Colors.white70,
    fontSize: 13,
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.black54,
    fontSize: 16,
  );
}

TextStyle medimTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}

Widget loadingContainer() {
  return Container(
      color: Colors.black.withOpacity(.3),
      child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          )
      )
  );
}

Decoration defaultBoxDecoration() {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient: LinearGradient(
          colors: [
            const Color(0xff007EE4),
            const Color(0xff2A75BC),
          ]
      )
  );
}

Widget myCustomBottomAppTab(int index, int selectedIndex, String text, String icon) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(icon == "chat" ? Icons.chat : Icons.person,
        color: selectedIndex == index ? Colors.white : Colors.white70,),
      Text(text,
        style: selectedIndex == index ?tabBarSelectedTextStyle() : tabBarUnSelectedTextStyle(),),
    ],
  );
}
