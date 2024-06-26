import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  TextEditingController controller;
  final String labelText;
  final bool obscureText;

  MyTextField({super.key,
    // Controls the text being edited
    //If user writes in there, we can this to access info
    required this.controller,
    required this.labelText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          labelText: labelText
      ),
    );
  }
}