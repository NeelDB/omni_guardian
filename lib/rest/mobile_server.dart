import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../network/wifi.dart';

class MobileServer {
  static const int _serverPort = 3000;
  static const String _alertService = '/processAlert';
  static const String _msgOK = 'Received photo!';
  static HttpServer? _server;

  static void startServer() async {
    final router = Router();
    router.post(_alertService, _handleRequest);
    _server = await HttpServer.bind(await Wifi.getUserIP(), _serverPort);

    _server?.listen((request) {
      final shelfRequest = Request(request.method, request.requestedUri,
          body: request);
      router(shelfRequest).then((shelfResponse) {
        request.response.statusCode = shelfResponse.statusCode;
        request.response.addStream(shelfResponse.read());
        request.response.close();
      });
    });
  }

  static void stopServer() {
    _server?.close();
    _server = null;
  }

  static Response _handleRequest(Request request) {
    //Photo.savePhoto(request);
    return Response.ok(_msgOK);
  }

}
