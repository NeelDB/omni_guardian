import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:omni_guardian/pages/alarm/alarm.dart';
import 'package:omni_guardian/rest/mobile_server.dart';
import 'package:omni_guardian/services/notif_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'dart:async';

import '../pages/home/home.dart';

class NetworkListener {
  static final Connectivity _connectivity = Connectivity();
  static String? _currentWifiSSID;
  static String? _homeWifiSSID;



  static Future<void> initListener() async {
    await Permission.location.request();
    await _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  static Future<void> _checkInitialConnection() async {
    await _connectivity.checkConnectivity();
    _homeWifiSSID = await WifiInfo().getWifiName();
    _currentWifiSSID = _homeWifiSSID;
  }

  static Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.first == ConnectivityResult.wifi) {
      String? newSSID = await WifiInfo().getWifiName();
      if(newSSID != null && newSSID == _homeWifiSSID) {
        debugPrint("Welcome Home! Don't forget to turn off the alarm!");
        NotificationService().showNotification(
            title: "Welcome back!",
            body: "Don't forget to turn off the alarm!"
        );
        await MobileServer.startServer();
      }
      else if (newSSID != null && newSSID != _currentWifiSSID) {
        debugPrint('Wi-Fi changed from $_currentWifiSSID to $newSSID');
        debugPrint("Not at home? Don't forget to turn on the alarm!");
        NotificationService().showNotification(
            title: "Not at home?",
            body: "Don't forget to turn on the alarm!"
        );
        _currentWifiSSID = newSSID;
      }
    } else if(result.first == ConnectivityResult.mobile) {
      await MobileServer.startServer();
      debugPrint("Using Mobile Net!");
      debugPrint("Not at home? Don't forget to turn on the alarm!");
      NotificationService().showNotification(
          title: "Not at home?",
          body: "Don't forget to turn on the alarm!"
      );
      _currentWifiSSID = null;
    } else {
      debugPrint("You're now in Offline Mode! Leaving home? Don't forget to turn on the alarm!");
      NotificationService().showNotification(
          title: "You're now in Offline Mode",
          body: "Leaving home? Don't forget to turn on the alarm!"
      );
      await MobileServer.stopServer();
      _currentWifiSSID = null;
    }
  }




}