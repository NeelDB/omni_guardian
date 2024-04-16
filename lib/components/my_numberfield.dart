import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyNumberField extends StatelessWidget {
  String number;
  final String labelText;

  MyNumberField({super.key,
    // Controls the text being edited
    //If user writes in there, we can this to access info
    required this.number,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill this box';
        }
        return null;
      },
      onSaved: (value) {
        number = value!; // Save the value when the form is saved
      },
    );
  }
}