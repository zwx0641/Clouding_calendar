import 'package:flutter/material.dart';

class AppInfoProvider with ChangeNotifier {
  String _themeColor = 'purple';

  String get themeColor => _themeColor;

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }
}