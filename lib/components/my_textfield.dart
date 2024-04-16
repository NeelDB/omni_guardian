import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String text;
  final String labelText;
  final bool obscureText;

  MyTextField({super.key,
    // Controls the text being edited
    //If user writes in there, we can this to access info
    required this.text,
    required this.labelText,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill this box';
        }
        return null;
      },
      onSaved: (value) {
        text = value!; // Save the value when the form is saved
      },
    );
  }
}