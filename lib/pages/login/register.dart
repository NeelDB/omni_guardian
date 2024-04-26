import 'package:flutter/material.dart';
import 'package:omni_guardian/colors.dart';
import 'package:omni_guardian/components/my_button.dart';
import 'package:omni_guardian/components/my_numberfield.dart';
import 'package:omni_guardian/components/my_textfield.dart';
import 'package:omni_guardian/components/square_tile.dart';
import 'package:omni_guardian/network/wifi.dart';
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
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final domain = TextEditingController();
  final domainAddress = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final alarmCode = TextEditingController();
  final guestCode = TextEditingController();
  final nCameras = TextEditingController();
  bool isAdmin = false;
  final String address = "default address";

  String? selectedRole;

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

              // Form to register user
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    MyRow(
                      leftWidget: //email
                      MyTextField(
                        controller: firstName,
                        labelText: 'First Name',
                        obscureText: false,
                      ),
                      rightWidget:
                      MyTextField(
                        controller: lastName,
                        labelText: 'Last Name',
                        obscureText: false,
                      ),
                    ),

                    const SizedBox(height: 15),

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

                    //Select between Admin or Guest
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      hint: const Text('Select Role'),
                      decoration: const InputDecoration(
                          labelText: 'Register as',
                          border: OutlineInputBorder(),
                          filled: true
                      ),
                      onChanged: (value) {
                        setState(() {
                          if(value == 'Admin') {
                            isAdmin = true;
                          }
                          else {
                            isAdmin = false;
                          }
                        });
                      },
                      items: ['Admin', 'Guest'].map((role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 15),

                    //Domain
                    MyTextField(
                      controller: domain,
                      labelText: 'Domain',
                      obscureText: false,
                    ),

                    Visibility(
                      visible: isAdmin,
                      child: Column(
                        children: [

                          const SizedBox(height: 15),

                          //Domain Address
                          MyTextField(
                            controller: domainAddress,
                            labelText: 'Domain Address',
                            obscureText: false,
                          ),

                          const SizedBox(height: 15),

                          //Alarm code
                          MyNumberField(
                              controller: alarmCode,
                              labelText: 'Alarm code',
                              obscureText: false,
                          ),

                          const SizedBox(height: 15),

                          //Number of cameras
                          MyNumberField(
                              controller: nCameras,
                              labelText: 'Number of cameras',
                              obscureText: false,
                          )
                        ],
                        // Add your logic for admin input handling
                      ),
                    ),

                    const SizedBox(height: 15),

                    MyNumberField(
                        controller: guestCode,
                        labelText: 'Guest code',
                        obscureText: false,
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //sign up button
              MyButton(
                onTap: () => AuthService(context)
                    .createUser(firstName.text, lastName.text, email.text, domain.text, guestCode.text, alarmCode.text, isAdmin, password.text, nCameras.text, address),
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
                  onTap: () => AuthService(context).authWithGoogle(),
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
