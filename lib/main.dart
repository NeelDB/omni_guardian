import 'package:flutter/material.dart';
import 'package:omni_guardian/network/networkListener.dart';
import 'package:omni_guardian/pages/auth_page.dart';
import 'package:omni_guardian/rest/mobile_server.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:omni_guardian/services/notif_service.dart';
import 'colors.dart';
import 'firebase_options.dart';
import 'network/bluetooth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
  await NetworkListener.initListener();
  //await Bluetooth.scanForDevices();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light, // Background color
        primaryColor: Color.fromRGBO(4, 18, 36, 1), // Primary color
        //hintColor: Color.fromRGBO(84, 117, 167, 1),

        colorScheme: const ColorScheme(
          background: Color(0xFFA0B9E1), // Background color
          primary: Color.fromRGBO(4, 18, 36, 1), // A darker version of the primary color
          secondary: Color.fromRGBO(232, 237, 241, 1), // A darker version of the secondary color
          surface: Color.fromRGBO(232, 237, 241, 1), // Surface color
          onBackground: Color.fromRGBO(4, 18, 36, 1), // On background color
          onPrimary: Color.fromRGBO(232, 237, 241, 1), // On primary color
          onSecondary: Color.fromRGBO(4, 18, 36, 1), // On secondary color
          onError: Colors.red, // Error color
          onSurface: Color.fromRGBO(4, 18, 36, 1), // On surface color
          error: Colors.red, // Error color
          brightness: Brightness.light,
        ),// Third color as accent



      ),
      debugShowCheckedModeBanner: false,
      home: const AuthPage()
    );
  }
}