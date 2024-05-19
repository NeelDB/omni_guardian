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
import '../network/bluetooth.dart';

class AuthService {

  final BuildContext context;
  AuthService(this.context);

  static const List<Alert> _defaultAlertList = [];
  static const String _defaultToken = 'Default token';
  static const String _defaultAlarmCode = 'Default alarm code';


  Future<void> createUser(String? email, String? password, String? confirmPassword, String firstName, String lastName, String domain, String guestCode, String alarmCode, bool isAdmin, String address) async {

    // Check if the password and confirm password match
    if (confirmPassword != null && password != confirmPassword) {
      errorMessage('The passwords do not match.');
      return; // Exit the function if the passwords don't match
    }

    try {

      String ip = await Wifi.getUserIP();
      String? userJson;

      if(isAdmin) {
        Camera cam1 = Camera("cam1", true, domain);
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

      //If its google sign up confirm password will be null
      if(confirmPassword != null) {
        await registerUser(email, password);
      }

    }
    on Exception catch(e) {
      errorMessage(e.toString());
      rethrow;
    }
  }

  Future<void> registerUser(String email, String password) async {

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // On successful registration, navigate to the home page or show a success message
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      switch (e.code) {
        case 'email-already-in-use':
          errorMsg = 'This email is already in use.';
          break;
        case 'invalid-email':
          errorMsg = 'Email address is not valid.';
          break;
        case 'weak-password':
          errorMsg = 'Your password does not meet the required strength.';
          break;
        default:
          errorMsg = 'An error occurred: ${e.code}';
          break;
      }
      errorMessage(errorMsg);
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signUserIn(String email, String password) async {
    try {
      await Storage.loadStorage(email, password);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    }

    on FirebaseAuthException catch (e) {

      String errorCode = e.code;

      if(errorCode == 'weak-password' || errorCode == 'user-not-found') {
        errorMessage('Email and/or password are incorrect');
      }
      else if(errorCode == 'invalid-email') {
        errorMessage('Please insert a valid email');
      }
      else {
        errorMessage(errorCode);
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw const NoGoogleAccountChosenException();
    }

    try {
      await Requests.getUserVerification(googleUser.email, googleUser.id);
    }

    on Exception catch(e) {
      errorMessage(e.toString());
    }

    await Storage.loadStorage(googleUser.email, googleUser.id);

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
    } on NoGoogleAccountChosenException {
      return;
    } catch (e) {
      errorMessage(e.toString());
    }
  }

  Future<void> registerWithGoogle(String firstName, String lastName, String domain, String guestCode, String alarmCode, bool isAdmin, String address) async {
    try {

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw const NoGoogleAccountChosenException();
      }

      await createUser(googleUser.email, googleUser.id, null, firstName, lastName, domain, guestCode, alarmCode, isAdmin, address);

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

    } on NoGoogleAccountChosenException {
      return;
    } on Exception {
      return;
    }
  }

  String? getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  Future<bool> codeIsCorrect(String code) async {
    Map<String, dynamic> user = await Storage.getUser();
    String alarmCode = user['alarmCode'];
    return code == alarmCode;
  }
}

class NoGoogleAccountChosenException implements Exception {
  const NoGoogleAccountChosenException();
}

