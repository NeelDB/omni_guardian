import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:omni_guardian/pages/alarm/alarm.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:omni_guardian/storage/storage.dart';
import '../network/wifi.dart';
import '../services/notif_service.dart';

class MobileServer {
  static const int _serverPort = 3000;
  static const String _alertService = '/processAlert';
  static const String _msgOK = 'Received photo!';
  static const String _cancelFlag = '[255]';
  static const String _modeFlag = '[170]';
  static const String _panicFlag = '[85]';
  static HttpServer? _server;
  static int countPassiveAlerts = 0;

  static Future<void> startServer() async {
    final router = Router();
    router.post(_alertService, _handleRequest);
    try {
      _server = await HttpServer.bind(await Wifi.getUserIP(), _serverPort);

      _server?.listen((request) {
        final shelfRequest = Request(request.method, request.requestedUri,
            body: request);
        router(shelfRequest).then((shelfResponse) {
          request.response.statusCode = shelfResponse.statusCode;
          shelfResponse.read().pipe(request.response).then((_) {
            request.response.close();
          });
        });
      });
    } catch(e) {
      print("Server lost connection!");
    }
  }

  static Future<void> stopServer() async {
    await _server?.close();
    _server = null;
  }

  static Future<Response> _handleRequest(Request request) async {
    String alertJson = await request.readAsString();
    Map<String, dynamic> alert = jsonDecode(alertJson);

    if(alert['imageBytes'].toString().isEmpty) {
      countPassiveAlerts++;

      if(countPassiveAlerts == 2) {
        print("Not seeing you around for a while, one more alert and the alarm will become active!");
        NotificationService().showNotification(
            title: "One more alert!",
            body: "Not seeing you around for a while, one more alert and the alarm will become active!"
        );
      }
      else if(countPassiveAlerts == 3) {
        print("Looks like you forgot to turned on the alarm, so it's about to become active right now!");
        NotificationService().showNotification(
            title: "Alarm about to activate",
            body: "Looks like you forgot to turned on the alarm, so it's about to become active right now!"
        );
        countPassiveAlerts = 0;
      }
      else {
        print("Not seeing you around, if you're gonna sleep don't forget to turn on the alarm!");
        NotificationService().showNotification(
            title: "Not seeing you around",
            body: "If you're gonna sleep don't forget to turn on the alarm!"
        );
      }
    }

    else if(base64.decode(alert['imageBytes']).toString() == _cancelFlag) {
      print("Alarm canceled!");
      NotificationService().showNotification(
          title: "Alarm canceled!",
          body: "Don't worry, it was false alarm!"
      );
    }

    else if(base64.decode(alert['imageBytes']).toString() == _modeFlag) {
      print("Alarm Mode changed!");
      NotificationService().showNotification(
          title: "Alarm Mode Changed!",
          body: "Someone has changed the alarm mode!"
      );
    }

    else if(base64.decode(alert['imageBytes']).toString() == _panicFlag) {
      print("Panic Alarm activated!");
      NotificationService().showNotification(
          title: "Panic Alarm activated!",
          body: "Be careful, someone activated the panic alarm!"
      );
    }

    else {
      alarmKey.currentState?.startTimer();
      Uint8List bytes = base64.decode(alert['imageBytes']);
      print("Received Alert!");
      NotificationService().showNotification(
          title: "Received Alert!",
          body: "Check out the alert"
      );
      print("Received PIR timestamp: ${alert['timestamp']}");
      print("Received PIR bytes: $bytes");
      await Storage.updateAlertStorage(alertJson);
    }

    return Response.ok(_msgOK);
  }

}
