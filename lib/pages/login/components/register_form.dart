import 'package:flutter/cupertino.dart';

import '../../../components/my_dropdown.dart';
import '../../../components/my_halft_textfield.dart';
import '../../../components/my_numberfield.dart';
import '../../../components/my_textfield.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.domainController,
    required this.alarmCodeController,
    required this.guestCodeController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController domainController;
  final TextEditingController alarmCodeController;
  final TextEditingController guestCodeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          // First name and Last Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //First name
              MyHalfTextfield(
                isLeft: true,
                inputField: MyTextField(
                  controller: firstNameController,
                  labelText: 'First Name',
                  obscureText: false,
                ),
              ),

              //Last name
              MyHalfTextfield(
                isLeft: false,
                inputField: MyTextField(
                  controller: lastNameController,
                  labelText: 'Last Name',
                  obscureText: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          //email
          MyTextField(
            controller: emailController,
            labelText: 'Email',
            obscureText: false,
          ),

          const SizedBox(height: 15),

          //password
          MyTextField(
            controller: passwordController,
            labelText: 'Password',
            obscureText: true,
          ),

          const SizedBox(height: 15),

          // Domain name and Admin code
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Domain name
              MyHalfTextfield(
                isLeft: true,
                inputField:
                  MyTextField(
                    controller: domainController,
                    labelText: 'Domain',
                    obscureText: false,
                  ),
              ),

              //Alarm code
              MyHalfTextfield(
                isLeft: false,
                inputField:
                  MyNumberField(
                      controller: alarmCodeController,
                      labelText: 'Alarm code'
                  ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Select Role and Guest Code
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Select Role -> Admin or Guest
              const MyHalfTextfield(
                isLeft: true,
                inputField:  MyDropdown(),
              ),

              //Guest Code
              MyHalfTextfield(
                isLeft: false,
                inputField:
                  MyNumberField(
                      controller: guestCodeController,
                      labelText: 'Guest code'
                  ),
              ),
            ],
          )
        ],
      ),
    );
  }
}