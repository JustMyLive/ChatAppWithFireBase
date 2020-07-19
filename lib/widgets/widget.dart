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
    color: Colors.black,
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

Widget loadingContainerOfConversation(bool isSendByMe) {
  return Container(
    alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
    padding: EdgeInsets.only(left: 7, bottom: 5, right: 7),
    width: 80,
//      child: UnconstrainedBox(
//        child: Container(
//          height: 20,
//          width: 20,
//          child: CircularProgressIndicator(
//            strokeWidth: 2,
//            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
//          ),
//        ),
//      ),
  );
}

Widget userHeaderImage(String userName) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 7),
    height: 40,
    width: 40,
    alignment: Alignment.center ,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(40),
    ),
    child: Text("${userName.substring(0,1).toUpperCase()}", style: medimTextStyle(),),
  );
}

Widget imageLoading() {
  return new Center(
    child: new SizedBox(
      width: 24.0,
      height: 24.0,
      child: new CircularProgressIndicator(
        strokeWidth: 2.0,
        backgroundColor: Colors.transparent,
      ),
    ),
  );
}
