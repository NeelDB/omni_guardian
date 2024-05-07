import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:omni_guardian/storage/storage.dart';
import '../network/wifi.dart';

class MobileServer {
  static const int _serverPort = 3000;
  static const String _alertService = '/processAlert';
  static const String _msgOK = 'Received photo!';
  static HttpServer? _server;

  static Future<void> startServer() async {
    final router = Router();
    router.post(_alertService, _handleRequest);
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
  }

  static void stopServer() {
    _server?.close();
    _server = null;
  }

  static Future<Response> _handleRequest(Request request) async {
    String alertJson = await request.readAsString();
    Map<String, dynamic> alert = jsonDecode(alertJson);
    Uint8List bytes = base64.decode(alert['imageBytes']);
    print("Received PIR timestamp: ${alert['timestamp']}");
    print("Received PIR bytes: $bytes");
    await Storage.updateAlertStorage(alertJson);
    return Response.ok(_msgOK);
  }

}
