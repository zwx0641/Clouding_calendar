import 'package:clouding_calendar/reminder.dart';
import 'package:clouding_calendar/signin.dart';
import 'package:clouding_calendar/signup.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'feedback.dart';
import 'help.dart';
import 'model/eventData.dart';

final routes = {
  'feedbackRoute': (BuildContext context) => new FeedbackPage(title: 'Feedbacks'),
  'helpRoute': (BuildContext context) => new HelpPage(),
  'homepageRoute': (BuildContext context) => new MyHomePage(),
  'reminderPageRoute': (BuildContext context) => new ReminderPage(),
  'signinRoute': (BuildContext context) => new SigninPage(),
  'signupRoute': (BuildContext context) => new SignupPage()
};



class Global {
  static final serverUrl = 'http://169.254.247.236:8080';
  static Map<DateTime, List> events = new Map();
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
  static List<EventData> eventData = new List<EventData>();

}

