import 'package:clouding_calendar/reminder.dart';
import 'package:flutter/material.dart';

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



class Global {
  static Map<DateTime, List> events = new Map();
  static final serverUrl = 'http://169.254.247.236:8080';
  static Map<int, String> repeatText = {
    0 : 'Do not repeat',
    1 : 'Every day',
    2 : 'Every week',
    3 : 'Every month',
    4 : 'Every year'
  };
  static Map<String, Color> themeColorMap = {
  'gray': Colors.grey,
  'blue': Colors.blue,
  'blueGrey': Colors.blueGrey,
  'cyan': Colors.cyan,
  'purple': Colors.purple,
  'deepPurple': Colors.deepPurple,
  'orange': Colors.orange,
  'green': Colors.green,
  'indigo': Colors.indigo,
  'amber': Colors.amber,
  'deepOrange': Colors.deepOrange,
  'purple': Colors.purple,
  'pink': Colors.pink,
  'red': Colors.red,
  'teal': Colors.teal,
  'lime': Colors.lime,
  };
  static String key_theme_color = 'purple';
  static int calendarType = 1;
}

