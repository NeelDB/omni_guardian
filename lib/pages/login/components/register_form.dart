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
    required this.nCamerasController
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController domainController;
  final TextEditingController alarmCodeController;
  final TextEditingController guestCodeController;
  final TextEditingController nCamerasController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          // First name and Last Name
          MyRow(
            leftWidget: //email
            MyTextField(
              controller: firstNameController,
              labelText: 'First Name',
              obscureText: false,
            ),
            rightWidget:
            MyTextField(
              controller: lastNameController,
              labelText: 'Last Name',
              obscureText: false,
            ),
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

          MyDropdown(
            alarmCodeController: alarmCodeController,
            nCamerasController: nCamerasController,
          ),

          const SizedBox(height: 15),

          MyNumberField(
              controller: guestCodeController,
              labelText: 'Guest code'
          )
        ],
      ),
    );
  }
}