import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final BuildContext context;
  AuthService(this.context);

  void createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseException catch(e) {
      showErrorMessage(e.code);
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

    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      showErrorMessage(e.code);
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
    } on NoGoogleAccountChosenException {
      return;
    } catch (e) {
      showErrorMessage(e.toString());
    }
  }

  String? getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }
}

class NoGoogleAccountChosenException implements Exception {
  const NoGoogleAccountChosenException();
}

