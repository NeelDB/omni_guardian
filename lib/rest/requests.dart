import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:omni_guardian/data/domain.dart';

import '../data/User.dart';


class Requests {

  // Home Server and Camera - Bessa
  static const String _serverHost = '192.168.1.74';
  static const String _cameraHost = '192.168.1.147';

  // Home Server and Camera - Neel
  //static const String _serverHost = '172.29.80.1';
  //static const String _cameraHost = '192.168.1.147';

  // Remote Server and Camera - Bessa
  //static const String _serverHost = '192.168.113.237';
  //static const String _cameraHost = '192.168.113.196';

  // Remote Server and Camera - Neel
  //static const String _serverHost = '192.168.1.32';
  //static const String _cameraHost = '192.168.105.196';

  static const int _serverPort = 8080;
  static const int _cameraPort = 80;

  static const String _service = 'omniguardian-server';
  static const String _serverBaseURI = 'http://$_serverHost:$_serverPort/$_service';
  static const String _cameraBaseURI = 'http://$_cameraHost:$_cameraPort';

  static const String _addAlertEndpoint = '/capture';
  static const String _addAlertURI = _cameraBaseURI + _addAlertEndpoint;

  static const String _cancelAlarmEndpoint = '/cancelAlarm';
  static const String _cancelAlarmURI = _cameraBaseURI + _cancelAlarmEndpoint;

  static const String _changeModeEndpoint = '/changeMode';
  static const String _changeModeURI = _cameraBaseURI + _changeModeEndpoint;

  static const String _activatePanicEndpoint = '/activatePanic';
  static const String _activatePanicURI = _cameraBaseURI + _activatePanicEndpoint;

  static const String _addAdminEndpoint = '/addAdmin';
  static const String _addAdminURI = _serverBaseURI + _addAdminEndpoint;

  static const String _addGuestEndpoint = '/addGuest';
  static const String _addGuestURI = _serverBaseURI + _addGuestEndpoint;

  static const String _listDomainsEndpoint = '/listDomains';
  static const String _listDomainsURI = _serverBaseURI + _listDomainsEndpoint;

  static const String _getUserEndpoint = '/getUser';
  static const String _getUserURI = _serverBaseURI + _getUserEndpoint;

  static const String _getUserVerificationEndpoint = '/getUserVerification';
  static const String _getUserVerificationURI = _serverBaseURI + _getUserVerificationEndpoint;

  static const String _getLastAlertEndpoint = '/getLastAlert';
  static const String _getLastAlertURI = _serverBaseURI + _getLastAlertEndpoint;

  static const String _getStorageEndpoint = '/getStorage';
  static const String _getStorageURI = _serverBaseURI + _getStorageEndpoint;

  static const String _getDefaultAlertEndpoint = '/getDefaultAlert';
  static const String _getDefaultAlertURI = _serverBaseURI + _getDefaultAlertEndpoint;

  static const String _getAlertsEndpoint = '/getAlerts';
  static const String _getAlertsURI = _serverBaseURI + _getAlertsEndpoint;

  static const String _getPositiveAlertsEndpoint = '/getPositiveAlerts';
  static const String _getPositiveAlertsURI = _serverBaseURI + _getPositiveAlertsEndpoint;

  static const String _getFalseAlertsEndpoint = '/getFalseAlerts';
  static const String _getFalseAlertsURI = _serverBaseURI + _getFalseAlertsEndpoint;

  static const int _ok = 200;
  static const int _forbidden = 403;
  static const int _notFound = 404;
  static const int _conflict = 409;

  static const String _applicationJson = 'application/json';

  static final _client = RetryClient(http.Client());


  static Future<String?> addAdmin(Domain domain) async {
    debugPrint(jsonEncode(domain.toJson()));
    final response = await _client.post(
        Uri.parse(_addAdminURI),
        headers: {'Content-Type': _applicationJson},
        body: jsonEncode(domain.toJson()));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;

    } else if(response.statusCode == _conflict) {
      debugPrint("Conflict: Domain already exists!");
      throw Exception('Conflict: Domain already exists!');
    }

    return null;
  }

  static Future<String?> addGuest(User guest) async {
    debugPrint(jsonEncode(guest.toJson()));
    final response = await _client.post(
        Uri.parse(_addGuestURI),
        headers: {'Content-Type': _applicationJson},
        body: jsonEncode(guest.toJson()));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;

    } else if(response.statusCode == _notFound) {
      debugPrint("Not Found: Domain name doesn't exist!");
      throw Exception('Not Found: Domain name doesn\'t exist!');

    } else if(response.statusCode == _forbidden) {
      debugPrint("Forbidden: Wrong Guest Code!");
      throw Exception('Forbidden: Wrong Guest Code!');
    }

    return null;
  }

  static Future<String?> addAlert() async {
    final response = await _client.get(Uri.parse(_addAlertURI));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;
    }

    return null;
  }

  static Future<void> cancelAlarm() async {
    final response = await _client.put(Uri.parse(_cancelAlarmURI));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
    }
  }

  static Future<void> changeMode() async {
    final response = await _client.put(Uri.parse(_changeModeURI));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
    }
  }

  static Future<void> activatePanic() async {
    final response = await _client.put(Uri.parse(_activatePanicURI));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
    }
  }




  static Future<String?> listDomains() async {
    final response = await _client.get(Uri.parse(_listDomainsURI));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;
    }

    return null;
  }


  static Future<String?> getUser(String email, String password) async {
    final response = await _client.get(Uri.parse("$_getUserURI/$email?password=$password"));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;

    } else if(response.statusCode == _forbidden) {
      debugPrint("Incorrect password!");
    }

    return null;
  }


  static Future<void> getUserVerification(String email, String password) async {
    final response = await _client.get(Uri.parse("$_getUserVerificationURI/$email?password=$password"));

    if(response.statusCode == _forbidden) {
      throw Exception("Incorrect password!");
    } else if(response.statusCode == -_notFound) {
      throw Exception("User not found!");
    }
  }


  static Future<String?> getLastAlert(String email, String password) async {
    final response = await _client.get(Uri.parse("$_getLastAlertURI/$email?password=$password"));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;

    } else if(response.statusCode == _forbidden) {
      debugPrint("Incorrect password!");
    }

    return null;
  }

  static Future<String?> getDefaultAlert() async {
    final response = await _client.get(Uri.parse(_getDefaultAlertURI));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;

    } else if(response.statusCode == _forbidden) {
      debugPrint("Incorrect password!");
    }

    return null;
  }

  static Future<String?> getStorage(String email, String password) async {
    final response = await _client.get(
        Uri.parse("$_getStorageURI/$email?password=$password"));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;
    } else if (response.statusCode == _forbidden) {
      debugPrint("Incorrect password!");
    }

    return null;
  }

  static Future<String?> getAlerts(String email, String token) async {
    final response = await _client.get(
        Uri.parse("$_getAlertsURI/$email?token=$token"));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;
    } else if (response.statusCode == _forbidden) {
      debugPrint("Incorrect token!");
    }

    return null;
  }

  static Future<String?> getPositiveAlerts(String email, String token) async {
    final response = await _client.get(
        Uri.parse("$_getPositiveAlertsURI/$email?token=$token"));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;
    } else if (response.statusCode == _forbidden) {
      debugPrint("Incorrect token!");
    }

    return null;
  }

  static Future<String?> getFalseAlerts(String email, String token) async {
    final response = await _client.get(
        Uri.parse("$_getFalseAlertsURI/$email?token=$token"));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;
    } else if (response.statusCode == _forbidden) {
      debugPrint("Incorrect token!");
    }

    return null;
  }

}