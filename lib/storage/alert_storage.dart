import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AlertStorage {

  static Future<void> updateAlertStorage(String alertJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('alertJson') != null) {
      prefs.remove('alertJson');
    }
    prefs.setString('alertJson', alertJson);
  }

  static Future<String> getAlertJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('alertJson') ?? '{}';
  }

  static Future<User> getAlert() async {
    String alertJson = await getAlertJson();
    return jsonDecode(alertJson);
  }

}
