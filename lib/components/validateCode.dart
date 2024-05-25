import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'my_numberfield.dart';

class CodeAlert {
  static void validateCode(
      BuildContext context,
      TextEditingController codeController,
      Function onSuccess,
      ) {
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
                if (await AuthService(context).codeIsCorrect(codeController.text)) {
                  onSuccess();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect code. Please try again.'),
                    ),
                  );
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
