import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:omni_guardian/data/domain.dart';

import '../data/User.dart';


class Requests {

  static const String serverHost = '192.168.1.74';
  static const int serverPort = 8080;
  static const String service = 'omniguardian-server';
  static const String serverBaseURI = 'http://$serverHost:$serverPort/$service';

  static const String addAdminEndpoint = '/addAdmin';
  static const String addAdminURI = serverBaseURI + addAdminEndpoint;

  static const String addGuestEndpoint = '/addGuest';
  static const String addGuestURI = serverBaseURI + addGuestEndpoint;

  static const String listDomainsEndpoint = '/listDomains';
  static const String listDomainsURI = serverBaseURI + listDomainsEndpoint;

  static const String getUserEndpoint = '/getUser';
  static const String getUserURI = serverBaseURI + getUserEndpoint;

  static const String getLastAlertEndpoint = '/getLastAlert';
  static const String getLastAlertURI = serverBaseURI + getLastAlertEndpoint;

  static const int ok = 200;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;

  static const String applicationJson = 'application/json';

  static final client = RetryClient(http.Client());


  static Future<String?> addAdmin(Domain domain) async {
    debugPrint(jsonEncode(domain.toJson()));
    final response = await client.post(
        Uri.parse(addAdminEndpoint),
        headers: {'Content-Type': applicationJson},
        body: jsonEncode(domain.toJson()));

    if (response.statusCode == ok) {
      debugPrint(response.body);
      return response.body;

    } else if(response.statusCode == conflict) {
      debugPrint("Conflict: Domain already exists!");

    } else {
      debugPrint(response.statusCode as String?);
    }

    return null;
  }

  static Future<String?> addGuest(User guest) async {
    debugPrint(jsonEncode(guest.toJson()));
    final response = await client.post(
        Uri.parse(addGuestEndpoint),
        headers: {'Content-Type': applicationJson},
        body: jsonEncode(guest.toJson()));

    if (response.statusCode == ok) {
      debugPrint(response.body);
      return response.body;

    } else if(response.statusCode == notFound) {
      debugPrint("Not Found: Domain name doesn't exist!");

    } else if(response.statusCode == forbidden) {
      debugPrint("Forbidden: Wrong Guest Code!");

    } else {
      debugPrint(response.statusCode as String?);
    }

    return null;
  }


  static Future<String?> listDomains() async {
    final response = await client.get(Uri.parse(listDomainsEndpoint));

    if (response.statusCode == ok) {
      debugPrint(response.body);
      return response.body;

    } else {
      debugPrint(response.statusCode as String?);
    }

    return null;
  }


  static Future<String?> getUser(String email, String password) async {
    final response = await client.get(Uri.parse("$getUserURI/$email?password=$password"));

    if (response.statusCode == ok) {
      debugPrint(response.body);
      return response.body;

    } else if(response.statusCode == forbidden) {
      debugPrint("Incorrect password!");

    } else {
      debugPrint(response.statusCode as String?);
    }
    return null;
  }


  static Future<String?> getLastAlert(String email, String password) async {
    final response = await client.get(Uri.parse("$getLastAlertEndpoint/$email?password=$password"));

    if (response.statusCode == ok) {
      debugPrint(response.body);
      return response.body;

    } else if(response.statusCode == forbidden) {
      debugPrint("Incorrect password!");

    } else {
      debugPrint(response.statusCode as String?);
    }
    return null;
  }





}