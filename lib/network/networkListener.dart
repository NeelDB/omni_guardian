import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'dart:async';

class NetworkListener {
  static final Connectivity _connectivity = Connectivity();
  static String? _currentWifiSSID;


  static Future<void> initListener() async {
    await Permission.location.request();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    await _checkInitialConnection();
  }

  static Future<void> _checkInitialConnection() async {
    List<ConnectivityResult> connection = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connection);
  }

  static Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    if (result.first == ConnectivityResult.wifi) {
      String? newSSID = await WifiInfo().getWifiName();
      if (newSSID != null && newSSID != _currentWifiSSID) {
        debugPrint('Wi-Fi changed from $_currentWifiSSID to $newSSID');
        _currentWifiSSID = newSSID;
      }
    } else if(result.first == ConnectivityResult.mobile) {
      debugPrint("Mobile net");
      _currentWifiSSID = null;

    } else {
      debugPrint('No Wifi Connection');
      _currentWifiSSID = null;
    }
  }




}