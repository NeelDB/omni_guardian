import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omni_guardian/data/alert.dart';
import 'package:omni_guardian/network/wifi.dart';
import 'package:omni_guardian/rest/requests.dart';
import 'package:omni_guardian/storage/storage.dart';
import '../data/Camera.dart';
import '../data/User.dart' as data;
import '../data/domain.dart';

class AuthService {

  final BuildContext context;
  AuthService(this.context);

  static const List<Alert> _defaultAlertList = [];
  static const String _defaultToken = 'Default token';
  static const String _defaultAlarmCode = 'Default alarm code';


  void createUser(String firstName, String lastName, String domain, String guestCode, String alarmCode,
      bool isAdmin, String nCameras, String address) async {

    try {
      String ip = await Wifi.getUserIP();
      String? userJson;
      String? email = getUserEmail();
      String? password = getUserUID();

      if(isAdmin) {
        Camera cam1 = Camera("cam1", false, domain);
        Camera cam2 = Camera("cam2", false, domain);

        data.User admin =
          data.User(firstName, lastName, email!, ip, domain, guestCode, alarmCode, isAdmin, _defaultToken, password!);

        Domain newDomain =
          Domain(domain, [cam1, cam2], [admin], _defaultAlertList, address, guestCode, alarmCode, _defaultToken);

        userJson = await Requests.addAdmin(newDomain);
      }

      else {
        data.User guest =
          data.User(firstName, lastName, email!, ip, domain, guestCode, _defaultAlarmCode, isAdmin, _defaultToken, password!);

        userJson = await Requests.addGuest(guest);
      }

      if(userJson != null) {
        await Storage.updateUserStorage(userJson);
      }

    }
    on FirebaseException catch(e) {
      String errorCode = e.code;

      if(errorCode == 'email-already-in-use') {
        showErrorMessage('This email is already in use');
      }
      else if(errorCode == 'invalid-email') {
        showErrorMessage("Email address is not valid");
      }
      else if(errorCode == 'weak-password') {
        showErrorMessage('Your password does not meet the required strength');
      }
      else {
        showErrorMessage(e.code);
      }
    }
  }

  void signUserIn(String email, String password) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // pop the loading circle
      Navigator.pop(context);

      await Storage.loadStorage(email, getUserUID()!);

      // TODO Test image
      String? alertJson = await Requests.addAlert();
      Map<String, dynamic> alert = jsonDecode(alertJson!);
      Uint8List bytes = base64.decode(alert['imageBytes']);
      debugPrint("Received timestamp: ${alert['timestamp']}");
      debugPrint("Received bytes: $bytes");
      await Storage.updateAlertStorage(alertJson);

    }

    on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      String errorCode = e.code;

      if(errorCode == 'weak-password' || errorCode == 'user-not-found') {
        showErrorMessage('Email and/or password are incorrect');
      }
      else if(errorCode == 'invalid-email') {
        showErrorMessage('Please insert a valid email');
      }
      else {
        showErrorMessage(errorCode);
      }
    }
  }

  void showErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw const NoGoogleAccountChosenException();
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );



    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> authWithGoogle() async {
    try {
      await signInWithGoogle();
      await Storage.loadStorage(getUserEmail()!, getUserUID()!);
    } on NoGoogleAccountChosenException {
      return;
    } catch (e) {
      showErrorMessage(e.toString());
    }
  }

  String? getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  String? getUserUID() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

}

class NoGoogleAccountChosenException implements Exception {
  const NoGoogleAccountChosenException();
}

