import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/colors.dart';
import 'package:omni_guardian/components/my_button.dart';
import 'package:omni_guardian/components/my_numberfield.dart';
import 'package:omni_guardian/components/my_textfield.dart';
import 'package:omni_guardian/components/square_tile.dart';
import 'package:omni_guardian/network/wifi.dart';
import 'package:omni_guardian/pages/login/register_form.dart';
import 'package:omni_guardian/services/auth_service.dart';


import '../../components/my_halft_textfield.dart';
import '../../data/User.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // text editing controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();


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
              Text('Let\'s create an account for you!',
                  style: TextStyle(
                      color: MyColors.textColorPrimary,
                      fontSize: 16
                  )
              ),

              const SizedBox(height: 25),

              // Form to register user
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    //email
                    MyTextField(
                      controller: email,
                      labelText: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 15),

                    //password
                    MyTextField(
                      controller: password,
                      labelText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 15),

                    //confirm password
                    MyTextField(
                      controller: confirmPassword,
                      labelText: 'Confirm Password',
                      obscureText: true,
                    ),


                  ],
                ),
              ),

              const SizedBox(height: 30),

              //sign up button
              MyButton(
                onTap: () {
                  registerUser(email.text, password.text, confirmPassword.text);
                },
                text: "Sign Up",
              ),


              const SizedBox(height: 30),

              //or register with
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
                  onTap: () => authWithGoogle(),
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

  Future<void> registerUser(String email, String password, String confirmPassword) async {

    // Check if the password and confirm password match
    if (password != confirmPassword) {
      errorMessage('The passwords do not match.');
      return; // Exit the function if the passwords don't match
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      // On successful registration, navigate to the home page or show a success message
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterForm()));
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

  Future<void> authWithGoogle() async {
    try {
      await AuthService(context).signInWithGoogle();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => RegisterForm()));

    } on NoGoogleAccountChosenException {
      return;
    } catch (e) {
      errorMessage(e.toString());
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
}
