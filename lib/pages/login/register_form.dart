import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';
import 'package:omni_guardian/homepage.dart';
import 'package:omni_guardian/pages/home/home.dart';
import 'package:omni_guardian/services/auth_service.dart';
import '../../colors.dart';
import '../../components/my_button.dart';
import '../../components/my_halft_textfield.dart';
import '../../components/my_numberfield.dart';
import '../../components/my_textfield.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // text editing controllers
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final domain = TextEditingController();
  final domainAddress = TextEditingController();
  final alarmCode = TextEditingController();
  final guestCode = TextEditingController();
  final nCameras = TextEditingController();
  bool isAdmin = false;
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: SafeArea(
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
              Text('Fill this form to register successfully',
                  style: TextStyle(
                      color: MyColors.textColorPrimary,
                      fontSize: 16
                  )
              ),

              const SizedBox(height: 25),

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
                onTap: () {
                  AuthService(context).createUser(
                      firstName.text,
                      lastName.text,
                      domain.text,
                      guestCode.text,
                      alarmCode.text,
                      isAdmin,
                      nCameras.text,
                      domainAddress.text);

                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));

                },
                text: "Submit",
              ),

              const SizedBox(height: 20)
            ],
          ),
        ),

      )
    );
  }
}