import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../homepage.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage( {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Checks if the user is logged in or not
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapchot) {
          // user is logged in
          if(snapchot.hasData) {
            return HomePage();
          }
          // user in not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}