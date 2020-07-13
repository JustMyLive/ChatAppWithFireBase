import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  
  static String sharePreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharePreferenceUserNameInKey = "USERNAMEKEY";
  static String sharePreferenceUserEmailInKey = "USEREMAILKEY";
  
  // Saving data to SharedPreference

  static Future<void> saveUserLoggedInSharePreference(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharePreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSharePreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharePreferenceUserNameInKey, userName);
  }

  static Future<void> saveUserEmailSharePreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharePreferenceUserEmailInKey, userEmail);
  }

  // Getting data to SharedPreference

  static Future<bool> getUserLoggedInSharePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(sharePreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharePreferenceUserNameInKey);
  }

  static Future<String> getUserEmailSharePreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharePreferenceUserEmailInKey);
  }

}