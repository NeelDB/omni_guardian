import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserStorage {

  static Future<void> updateUserStorage(String userJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userJson') != null) {
      prefs.remove('userJson');
    }
    prefs.setString('userJson', userJson);
  }

  static Future<String> getUserJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userJson') ?? '{}';
  }

  static Future<User> getUser() async {
    String userJson = await getUserJson();
    return jsonDecode(userJson);
  }

}
