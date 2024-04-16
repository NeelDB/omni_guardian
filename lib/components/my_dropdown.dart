import 'package:flutter/material.dart';

import 'my_numberfield.dart';

class MyDropdown extends StatefulWidget {

  final TextEditingController alarmCodeController;
  final TextEditingController nCamerasController;

  const MyDropdown({
    Key? key,
    required this.alarmCodeController,
    required this.nCamerasController,
  }) : super(key: key);

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {

  String dropdownValue = '';
  bool isAdminSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
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
              setState(() {
                dropdownValue = value!;
                if (dropdownValue == 'Admin') {
                  isAdminSelected = true;
                } else if (dropdownValue == 'Guest') {
                  isAdminSelected = false;
                }
              });
            },
            onSaved: (value) {
              dropdownValue = value!;
            }
        ),

        Visibility(
          visible: isAdminSelected,
          child: Column(
            children: [

              const SizedBox(height: 15),

              //Alarm code
              MyNumberField(
                  controller: widget.alarmCodeController,
                  labelText: 'Alarm code'
              ),

              const SizedBox(height: 15),

              //Number of cameras
              MyNumberField(
                  controller: widget.nCamerasController,
                  labelText: 'Number of cameras'
              )
            ],
            // Add your logic for admin input handling
          ),
        ),
      ],
    );
  }
}