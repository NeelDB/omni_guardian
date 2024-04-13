import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDropdown extends StatefulWidget {
  const MyDropdown({super.key});

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {

  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Register as',
        border: OutlineInputBorder(),
        filled: true
      ),
      items: ['Admin', 'Guest']
          .map((String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ))
          .toList(),
      onChanged: (value) {
        dropdownValue = value!;
      },
      onSaved: (value) {
        dropdownValue = value!;
      }
    );
  }

}