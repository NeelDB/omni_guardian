import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';

import '../../components/my_numberfield.dart';
import '../../services/auth_service.dart';

class Alarm extends StatefulWidget {
  Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  final codeController = TextEditingController();
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Alarm'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              const SizedBox(height: 100),

              //Turn System on/off
              ElevatedButton.icon(
                  onPressed: () {_showCodeInputDialog(context);},
                  icon: isOn? const Icon(Icons.cancel) : const Icon(Icons.notification_important, size: 40),
                  label: isOn? const Text('Panic Button Off') : const Text('Panic Button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOn? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(300, 80),
                    //side: const BorderSide(color: Colors.black, width: 2),
                    shape: const RoundedRectangleBorder(),
                    textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _showCodeInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Code'),
          content: MyNumberField(
            labelText: 'Code',
            controller: codeController,
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if(await AuthService(context).codeIsCorrect(codeController.text)) {
                  if(isOn) {
                    setState(() {isOn = false;});
                  }
                  else {setState(() {isOn = true;});
                  }
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Incorrect code. Please try again.'),
                      ));
                }
                codeController.text = '';
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}