import 'package:flutter/material.dart';
import 'package:omni_guardian/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if(_themeData == lightMode) {
      _themeData = darkMode;
    }
    else {
      _themeData = lightMode;
    }
  }


}