import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/colors.dart';
import 'package:omni_guardian/components/my_button.dart';
import 'package:omni_guardian/components/my_textfield.dart';
import 'package:omni_guardian/components/square_tile.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  final Function()? onTap;
  const Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(context: context, builder: (context) {
      return const Center(child: CircularProgressIndicator());
    });
    // try sign in

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

      // pop the loading circle
      Navigator.pop(context);

    } on FirebaseAuthException catch(e) {
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

    if(googleUser == null) {
      throw const NoGoogleAccountChosenException();
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> authWithGoogle() async {
    try {
      await signInWithGoogle();
    }
    on NoGoogleAccountChosenException{
      return;
    }
    catch(e) {
      showErrorMessage('An unknown error occurred');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: SafeArea( //Safe Area makes the UI avoid the corners and notch of the screen
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
            
                //logo
                Image.asset(
                    'assets/images/OmniGuardian.jpg',
                  height: 100,
                  width: 100,
                ),
            
                const SizedBox(height: 30),
            
                //Welcome back, you've been missed
                Text('Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: MyColors.textColorPrimary,
                    fontSize: 16
                  )
                ),
            
                const SizedBox(height: 25),
            
                //email
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),
            
                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 10),
            
                //forgot password
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 25),
            
                //sign in button
                MyButton(
                  onTap: signUserIn,
                  text: "Sign In",
                ),
            
                const SizedBox(height: 30),
            
                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700])
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 20),
            
                //google sign in
                SquareTile(
                  //onTap: () => AuthService().signInWithGoogle(),
                  onTap: authWithGoogle,
                  imagePath: 'assets/images/google.png'
                ),
            
                const SizedBox(height: 20),
            
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700])
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    )
                  ],
                ),
            
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
    );
  }
}

class NoGoogleAccountChosenException implements Exception {
  const NoGoogleAccountChosenException();
}