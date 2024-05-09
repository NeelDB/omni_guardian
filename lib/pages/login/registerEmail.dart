import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../../components/my_halft_textfield.dart';
import '../../components/my_numberfield.dart';
import '../../components/my_textfield.dart';
import '../../services/auth_service.dart';

class RegisterEmail extends StatefulWidget {
  const RegisterEmail({super.key});

  @override
  State<RegisterEmail> createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {

  // text editing controllers
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final domain = TextEditingController();
  final domainAddress = TextEditingController();
  final alarmCode = TextEditingController();
  final guestCode = TextEditingController();
  bool isAdmin = false;
  String? selectedRole;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
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

                const SizedBox(height: 15),

                MyRow(
                  leftWidget:
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
                    ],
                    // Add your logic for admin input handling
                  ),
                ),

                const SizedBox(height: 15),

                MyNumberField(
                  controller: guestCode,
                  labelText: 'Guest code',
                  obscureText: false,
                ),

                const SizedBox(height: 30),

                //sign up button
                isLoading? const CircularProgressIndicator():
                MyButton(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await AuthService(context).createUser(
                        email.text,
                        password.text,
                        confirmPassword.text,
                        firstName.text,
                        lastName.text,
                        domain.text,
                        guestCode.text,
                        alarmCode.text,
                        isAdmin,
                        domainAddress.text
                    );
                    setState(() {
                      isLoading = false;
                    });
                  },
                  text: "Sign Up",
                ),

                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}