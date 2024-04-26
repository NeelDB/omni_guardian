import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omni_guardian/components/my_app_bar.dart';
import 'package:omni_guardian/components/my_numberfield.dart';
import 'package:omni_guardian/services/auth_service.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final codeController = TextEditingController();
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Home'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: [
                const Text(
                    'Domain Name',
                    style: TextStyle(
                      fontSize: 40,
                      fontStyle: FontStyle.italic
                    ),
                  ),

                const SizedBox(height: 30),

                //Turn System on/off
                ElevatedButton.icon(
                    onPressed: () {_showCodeInputDialog(context);},
                    icon: isOn? const Icon(Icons.cancel) : const Icon(Icons.power_settings_new, size: 40),
                    label: isOn? const Text('Turn off') : const Text('Turn on'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOn? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(300, 80),
                      side: const BorderSide(color: Colors.black, width: 2),
                      shape: const RoundedRectangleBorder(),
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),

                const SizedBox(height: 60),

                //Add camera
                ElevatedButton.icon(
                  onPressed: (){},
                  icon: const Icon(Icons.add),
                  label: const Text('Add Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(300, 40),
                    side: const BorderSide(color: Colors.black, width: 2),
                    shape: const RoundedRectangleBorder(),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),

                /*Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Outline color
                      width: 2.0, // Outline width
                    ),
                  ),
                  child: const Row(
                    children: <Widget>[
                      Switch(value: true, onChanged: null),
                      Text('Camera 1')
                    ],
                  ),
                ) */
              ],
          ),
        ),
      )
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
              onPressed: () {
                if(_codeIsCorrect()) {
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

  bool _codeIsCorrect() {
    return codeController.text == '1234';
  }
}