import 'package:flutter/material.dart';
import 'package:omni_guardian/colors.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.teal[100],
    colorScheme: const ColorScheme.light(
      //background: Colors.grey.shade400,
      //primary: MyColors.primaryColor
    )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        //background: Colors.grey.shade900,
        //primary: Colors.grey.shade800
    )
);
