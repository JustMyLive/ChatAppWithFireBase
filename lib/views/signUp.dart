import 'package:ChatAppWithFireBase/helper/helperfunctions.dart';
import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/services/database.dart';
import 'package:ChatAppWithFireBase/views/tabbars.dart';
import 'package:flutter/material.dart';
import 'package:ChatAppWithFireBase/services/auth.dart';
import 'package:ChatAppWithFireBase/widgets/widget.dart';

import 'chatRoom.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text,
      };

      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) async {
        //print("${val.uid}");

        var documentID = await dataBaseMethods.uploadUserInfo(userInfoMap);

        HelperFunctions.saveUserLoggedInSharePreference(true);
        HelperFunctions.saveUserNameSharePreference(userNameTextEditingController.text);
        HelperFunctions.saveUserEmailSharePreference(emailTextEditingController.text);
        HelperFunctions.saveUserDocumentIdSharePreference(documentID);

        replace(context, TabBars());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading ? Container(
          child: Center(child: CircularProgressIndicator(),),
        ) : SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height-70,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (val) {
                            return val.isEmpty || val.length < 2 ? "Please Provide UserName" : null;
                          },
                          controller: userNameTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFiledInputDecoration("userName"),
                        ),
                        TextFormField(
                          validator: (val) {
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                              null : "Enter correct email";
                          },
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFiledInputDecoration("email"),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator:  (val){
                            return val.length < 6 ? "Enter Password 6+ characters" : null;
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFiledInputDecoration("password"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("Forgot Password?", style: simpleTextStyle(),),
                    ),
                  ),
                  SizedBox(height: 8,),
                  GestureDetector(
                    onTap: () {
                      //TODO
                      signMeUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xff007EE4),
                                const Color(0xff2A75BC),
                              ]
                          )
                      ),
                      child: Text("Sign Up", style: medimTextStyle()
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Text("Sign In with Google", style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17
                    ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center ,
                    children: <Widget>[
                      Text("Already have account? ", style: TextStyle(
                        color: Colors.black54,
                        fontSize: 17
                      ),),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("SignIn now", style:  TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                          ),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 70,),
                ],
              ),
            ),
          ),
        )
    );
  }
}
