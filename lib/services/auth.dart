import 'package:firebase_auth/firebase_auth.dart';
import 'package:ChatAppWithFireBase/model/user.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFireBaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFireBaseUser(firebaseUser);
    } catch(error) {
      print(error);
      return;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFireBaseUser(firebaseUser);
    } catch(error) {
      print(error);
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(error) {
      print(error);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(error) {
      print(error);
    }
  }
}