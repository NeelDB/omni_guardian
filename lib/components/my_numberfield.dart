import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyNumberField extends StatelessWidget {
  TextEditingController controller;
  final String labelText;
  final bool obscureText;

  MyNumberField({super.key,
    // Controls the text being edited
    //If user writes in there, we can this to access info
    required this.controller,
    required this.labelText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: obscureText,
      inputFormatters: [
        LengthLimitingTextInputFormatter(4),
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
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
      )
    );
  }
}