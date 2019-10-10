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