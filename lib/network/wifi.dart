import 'package:network_info_plus/network_info_plus.dart';

class Wifi {

  static const String _unknownIP = 'Unknown IP Address';
  static final NetworkInfo _networkInfo = NetworkInfo();

  static Future<String> getUserIP() async {
    String? ipAddress = await _networkInfo.getWifiIP();
    return ipAddress ?? _unknownIP;
  }

}