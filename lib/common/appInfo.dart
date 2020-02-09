import 'package:flutter/material.dart';

class AppInfoProvider with ChangeNotifier {
  String _themeColor = 'deepOrange';

  String get themeColor => _themeColor;

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }
}