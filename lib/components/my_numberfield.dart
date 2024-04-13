import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyNumberField extends StatelessWidget {
  final controller;
  final String labelText;

  const MyNumberField({super.key,
    // Controls the text being edited
    //If user writes in there, we can this to access info
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
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
        ),
      ),
    );
  }
}