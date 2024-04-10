import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

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
            return Home();
          }
          // user in not logged in
          else {
            return Login();
          }
        },
      ),
    );
  }
}