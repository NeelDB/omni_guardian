import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../../components/my_halft_textfield.dart';
import '../../components/my_numberfield.dart';
import '../../components/my_textfield.dart';
import '../../services/auth_service.dart';

class RegisterGoogle extends StatefulWidget {
  const RegisterGoogle({super.key});

  @override
  State<RegisterGoogle> createState() => _RegisterGoogleState();
}

class _RegisterGoogleState extends State<RegisterGoogle> {
  // text editing controllers
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final domain = TextEditingController();
  final domainAddress = TextEditingController();
  final alarmCode = TextEditingController();
  final guestCode = TextEditingController();
  bool isAdmin = false;
  String? selectedRole;

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
                MyButton(
                  onTap: () {
                    AuthService(context).registerWithGoogle(
                        firstName.text,
                        lastName.text,
                        domain.text,
                        guestCode.text,
                        alarmCode.text,
                        isAdmin,
                        domainAddress.text
                    );
                  },
                  text: "Submit",
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