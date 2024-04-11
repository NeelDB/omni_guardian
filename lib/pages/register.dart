import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:omni_guardian/colors.dart';
import 'package:omni_guardian/components/my_button.dart';
import 'package:omni_guardian/components/my_textfield.dart';
import 'package:omni_guardian/components/square_tile.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final domainController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserUp() async {
    // show loading circle
    showDialog(context: context, builder: (context) {
      return const Center(child: CircularProgressIndicator());
    });

    // try creating the user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text);

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

              //Let's create an account for you
              Text('Let\'s  create an account for you!',
                  style: TextStyle(
                      color: MyColors.textColorPrimary,
                      fontSize: 16
                  )
              ),

              const SizedBox(height: 25),

              //First name
              MyTextField(
                controller: firstNameController,
                hintText: 'First Name',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              //Last name
              MyTextField(
                controller: lastNameController,
                hintText: 'Last Name',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              //Domain
              MyTextField(
                controller: domainController,
                hintText: 'Domain',
                obscureText: false,
              ),

              const SizedBox(height: 10),

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

              const SizedBox(height: 30),

              //sign in button
              MyButton(
                onTap: signUserUp,
                text: "Sign Up",
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
                          'Or register with',
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
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700])
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                        'Login Now',
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