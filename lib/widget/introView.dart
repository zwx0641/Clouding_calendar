  //making list of pages needed to pass in IntroViewsFlutter constructor.
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';

final pages = [
    PageViewModel(
        pageColor: const Color(0xFF03A9F4),
        // iconImageAssetPath: 'images/air-hostess.png',
        bubble: Image.asset('images/calendar_small.png'),
        body: Text(
          'Beautiful calendar views, easy to use',
        ),
        title: Text(
          'Welcome to Zalendar',
        ),
        titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Image.asset(
          'images/welcomeintro.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      iconImageAssetPath: 'images/reminder_small.png',
      body: Text(
        'Just a single tap, never forget things',
      ),
      title: Text('Reminders'),
      mainImage: Image.asset(
        'images/reminderintro.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      iconImageAssetPath: 'images/event_small.png',
      body: Text(
        'Keep your emergencies in our app, we will remember everything for you',
      ),
      title: Text('Events'),
      mainImage: Image.asset(
        'images/eventintro.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];