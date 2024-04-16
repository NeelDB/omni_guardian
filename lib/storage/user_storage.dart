import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omni_guardian/rest/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/alert.dart';


class UserStorage {

  static const String userData = 'userData';
  static const String alertData = 'alertData';

  static Future<void> updateUserStorage(String userJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(userData) != null) {
      prefs.remove(userData);
    }
    prefs.setString(userData, userJson);
  }

  static Future<void> loadUserStorage(String email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(userData) == null) {
      String? userJson = await Requests.getUser(email, password);
      if(userJson != null) {
        prefs.setString(userData, userJson);
      }
    }
  }

  static Future<String> getUserJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userData) ?? '{}';
  }

  static Future<User> getUser() async {
    return jsonDecode(await getUserJson());
  }


  static Future<void> updateAlertStorage(String alertJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(alertData) != null) {
      prefs.remove(alertData);
    }
    prefs.setString(alertData, alertJson);
  }

  static Future<void> loadAlertStorage(String email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(alertData) == null) {
      String? alertJson = await Requests.getLastAlert(email, password);
      if(alertJson != null) {
        prefs.setString(alertData, alertJson);
      }
    }
  }

  static Future<String> getAlertJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(alertData) ?? '{}';
  }

  static Future<Alert> getAlert() async {
    return jsonDecode(await getAlertJson());
  }

  //TODO correct
  static Future<void> loadStorage(String email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(alertData) == null && prefs.getString(userData) == null) {
      String? alertJson = await Requests.getLastAlert(email, password);
      if(alertJson != null) {
        prefs.setString(alertData, alertJson);
      }
    }
  }

}
