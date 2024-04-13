import 'package:flutter/cupertino.dart';

import '../../../components/my_dropdown.dart';
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
          //First name
          MyTextField(
            controller: firstNameController,
            labelText: 'First Name',
            obscureText: false,
          ),

          const SizedBox(height: 15),

          //Last name
          MyTextField(
            controller: lastNameController,
            labelText: 'Last Name',
            obscureText: false,
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


          //Domain
          MyTextField(
            controller: domainController,
            labelText: 'Domain',
            obscureText: false,
          ),

          const SizedBox(height: 15),

          //Domain code
          MyNumberField(
              controller: alarmCodeController,
              labelText: 'Alarm code'
          ),

          const SizedBox(height: 15),

          //Select Role -> Admin or Guest
          const MyDropdown(),

          const SizedBox(height: 15),

          //Guest Code
          MyNumberField(
              controller: guestCodeController,
              labelText: 'Guest code'
          ),
        ],
      ),
    );
  }
}