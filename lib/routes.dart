import 'package:clouding_calendar/reminder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'feedback.dart';
import 'help.dart';
import 'login.dart';

final routes = {
  'feedbackRoute': (BuildContext context) => new FeedbackPage(),
  'helpRoute': (BuildContext context) => new HelpPage(),
  'homepageRoute': (BuildContext context) => new MyHomePage(),
  'loginRoute': (BuildContext context) => new LoginPage(),
  'reminderPageRoute': (BuildContext context) => new ReminderPage()
};

final serverUrl = 'http://172.17.95.177:8080';

setGlobalUserInfo(user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("userInfo", user);
}

Future<String> getGlobalUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("userInfo");
}

deleteGloabalUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("userInfo");
}