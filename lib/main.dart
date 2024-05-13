import 'package:flutter/material.dart';
import 'package:omni_guardian/network/bluetooth.dart';
import 'package:omni_guardian/pages/auth_page.dart';
import 'package:omni_guardian/rest/mobile_server.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await MobileServer.startServer();
  //await Bluetooth.scanForDevices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage()
    );
  }
}