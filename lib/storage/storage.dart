import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omni_guardian/rest/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/alert.dart';


class Storage {

  static const String _userData = 'userData';
  static const String _alertData = 'alertData';

  static Future<void> updateUserStorage(String userJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_userData) != null) {
      prefs.remove(_userData);
    }
    prefs.setString(_userData, userJson);
  }

  static Future<void> loadUserStorage(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_userData) == null) {
      String? userJson = await Requests.getUser(email, password);
      if(userJson != null) {
        prefs.setString(_userData, userJson);
      }
    }
  }

  static Future<String> getUserJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userData) ?? '{}';
  }

  static Future<Map<String, dynamic>> getUser() async {
    return jsonDecode(await getUserJson());
  }


  static Future<void> updateAlertStorage(String alertJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_alertData) != null) {
      prefs.remove(_alertData);
    }
    prefs.setString(_alertData, alertJson);
  }

  static Future<void> loadAlertStorage(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_alertData) == null) {
      String? alertJson = await Requests.getLastAlert(email, password);
      if(alertJson != null) {
        prefs.setString(_alertData, alertJson);
      }
    }
  }

  static Future<String> getAlertJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_alertData) ?? '{}';
  }

  static Future<Map<String, dynamic>> getAlert() async {
    return jsonDecode(await getAlertJson());
  }


  static Future<void> loadStorage(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storageJson = await Requests.getStorage(email, password);
    if(storageJson != null) {
      Map<String, dynamic> storageData = jsonDecode(storageJson);
      prefs.setString(_userData, jsonEncode(storageData['user']));
      prefs.setString(_alertData, jsonEncode(storageData['alert']));
    }
  }

}
