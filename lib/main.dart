import 'package:flutter/material.dart';
import 'package:omni_guardian/network/networkListener.dart';
import 'package:omni_guardian/pages/alarm/alarm.dart';
import 'package:omni_guardian/pages/auth_page.dart';
import 'package:omni_guardian/rest/mobile_server.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:omni_guardian/services/notif_service.dart';
import 'package:omni_guardian/theme/theme.dart';
import 'package:omni_guardian/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'colors.dart';
import 'firebase_options.dart';
import 'network/bluetooth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
      ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp()
      )
  );
  await NetworkListener.initListener();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const AuthPage()
    );
  }
}