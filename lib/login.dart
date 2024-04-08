import 'package:flutter/material.dart';
import 'package:omni_guardian/colors.dart';
import 'package:omni_guardian/components/my_button.dart';
import 'package:omni_guardian/components/my_textfield.dart';
import 'package:omni_guardian/components/square_tile.dart';

class Login extends StatelessWidget {
  Login({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor, // Atencao cor pode mudar
      body: SafeArea( //Safe Area makes the UI avoid the corners and notch of the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            //logo
            Image.asset(
                'assets/images/OmniGuardian.jpg',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 50),

            //Welcome back, you've been missed
            Text('Welcome back, you\'ve been missed!',
              style: TextStyle(
                color: MyColors.textColorPrimary,
                fontSize: 16
              )
            ),

            const SizedBox(height: 25),

            //username textfield
            MyTextField(
              controller: usernameController,
              hintText: 'Username',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            //password textfield
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
            const MyButton(
              onTap: sign
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

            const SizedBox(height: 30),
            //google sign in
            const SquareTile(imagePath: 'assets/images/google.png'),

            const SizedBox(height: 30),

            //not a member? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member?',
                  style: TextStyle(color: Colors.grey[700])
                ),
                const SizedBox(width: 4),
                const Text(
                  'Register Now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//Depois substituir com a cena que esta la em cima
void sign() {}