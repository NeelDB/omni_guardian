import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:omni_guardian/data/domain.dart';

import '../data/User.dart';


class Requests {

  static const String _serverHost = '192.168.1.74';
  static const String _cameraHost = '192.168.1.147';

  static const int _serverPort = 8080;
  static const int _cameraPort = 80;

  static const String _service = 'omniguardian-server';
  static const String _cameraService = 'capture';

  static const String _serverBaseURI = 'http://$_serverHost:$_serverPort/$_service';
  static const String _cameraBaseURI = 'http://$_cameraHost:$_cameraPort/$_cameraService';

  static const String _addAdminEndpoint = '/addAdmin';
  static const String _addAdminURI = _serverBaseURI + _addAdminEndpoint;

  static const String _addGuestEndpoint = '/addGuest';
  static const String _addGuestURI = _serverBaseURI + _addGuestEndpoint;

  static const String _listDomainsEndpoint = '/listDomains';
  static const String _listDomainsURI = _serverBaseURI + _listDomainsEndpoint;

  static const String _getUserEndpoint = '/getUser';
  static const String _getUserURI = _serverBaseURI + _getUserEndpoint;

  static const String _getLastAlertEndpoint = '/getLastAlert';
  static const String _getLastAlertURI = _serverBaseURI + _getLastAlertEndpoint;

  static const String _getStorageEndpoint = '/getStorage';
  static const String _getStorageURI = _serverBaseURI + _getStorageEndpoint;

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

    } else if(response.statusCode == _forbidden) {
      debugPrint("Forbidden: Wrong Guest Code!");
    }

    return null;
  }

  static Future<String?> addAlert() async {
    final response = await _client.get(Uri.parse(_cameraBaseURI));

    if (response.statusCode == _ok) {
      debugPrint(response.body);
      return response.body;
    }

    return null;
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

}