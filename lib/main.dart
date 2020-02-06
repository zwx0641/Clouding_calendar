import 'dart:async';
import 'dart:convert';

import 'package:clouding_calendar/custom_router.dart';
import 'package:clouding_calendar/local_notification_helper.dart';
import 'package:clouding_calendar/login.dart';
import 'package:clouding_calendar/reminder.dart';
import 'package:clouding_calendar/routes.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:clouding_calendar/template.dart';
import 'routes.dart' as rt;
import 'package:http/http.dart' as http;
import 'userServices.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      /* home: MyHomePage(title: "ZENO's calendar"), */
      home: FutureBuilder<bool>(
            future: getUserLoginState(),
             builder:(BuildContext context, AsyncSnapshot<bool> snapshot){
          if (snapshot.data == true){
            return MyHomePage();
          }
          else{
            return LoginPage();
          }
        }
      ),
      routes: prefix0.routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key, 
    this.title,
    }) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  //Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  FlutterLocalNotificationsPlugin notifications = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    getReminder();
    startTimer();
    /* rt.Global.events = {
      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    }; */

    _selectedEvents = rt.Global.events[_selectedDay] ?? [];

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    notifications.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => MyHomePage())
);

  Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  showDialog(
    context: context,
    builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new MyHomePage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

//日历视图按钮
  SelectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                new Icon(icon, color: Colors.blue),
                new Text(text),
                
            ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        ////右上角选择日历视图
        actions: <Widget>[
          new PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  this.SelectView(Icons.settings, 'Settings', 'A'),
              ],
              onSelected: (String action) {
                  // 点击按钮更换视图
                  switch (action) {
                      case 'A': {
                        Navigator.pop(context);
                      }
                      break;
                  }
              },
          )
        ],
        title: Text('A clouding calendar'),
      ),
      //左侧抽屉
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            header,
            ListTile(
              title: Text('Month'),
              leading: new CircleAvatar(child: new Icon(Icons.today),),
              onTap: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month); 
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('2weeks'),
              leading: new CircleAvatar(child: new Icon(Icons.view_agenda),),
              onTap: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.twoWeeks); 
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Week'),
              leading: new CircleAvatar(child: new Icon(Icons.view_day),),
              onTap: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week); 
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Search'),
              leading: new CircleAvatar(child: new Icon(Icons.search),),
              onTap: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week); 
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: new CircleAvatar(child: new Icon(Icons.settings),),
              onTap: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week); 
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Help'),
              leading: new CircleAvatar(child: new Icon(Icons.help),),
              onTap: () {
                Navigator.popAndPushNamed(context, 'helpRoute');
              },
            ),
            ListTile( 
              leading: new CircleAvatar(child: new Icon(Icons.feedback),),
              onTap: () {
                Navigator.popAndPushNamed(context, 'feedbackRoute');
              },
            ),
            ListTile(
              title: Text('Logout'),
              leading: new CircleAvatar(child: new Icon(Icons.power_settings_new),),
              onTap: () {
                logout();
              },
            )
          ],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          //_buildButtons(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        onPressed: _AddActivities,
        child: new Icon(Icons.add),
      ),
    );
  }

  //点击加号按钮触发的事件
  void _AddActivities() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              Container(
                height: 25,
                width: double.infinity,
                color: Colors.black54,
              ),
              Container(
                height: 112,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //添加需要完成的事件
                    new ListTile(
                      leading: new Icon(Icons.event, color: Colors.white),
                      title: new Text('Event', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(new CustomRoute(new ReminderPage()));
                      },
                    ),
                    //添加提醒
                    new ListTile(
                      leading: new Icon(Icons.alarm_add, color: Colors.white),
                      title: new Text('Reminder', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(new CustomRoute(new ReminderPage()));
                      },
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)
                  )
                ),
              ),
              
            ],
          );
        }
      );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: rt.Global.events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarController,
      events: rt.Global.events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  logout() async {
    //获取本地缓存
    var userId = await getGlobalUserInfo();
    var url = rt.Global.serverUrl + '/logout?userId=' + userId; 
    //删除redis缓存
    var response = await http.post(
      Uri.encodeFull(url),
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      }
    );
    var data = jsonDecode(response.body.toString());
    var status = data['status'];

    if (status == 200) {
      Fluttertoast.showToast(
        msg: 'Logout successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER
      );
      //删除本地缓存
      deleteGloabalUserInfo();
      //设user没有login
      setUserLoginState(false);
      Navigator.popAndPushNamed(context, 'loginRoute');
    }
  }

  startTimer() async {
    //设置一个监视器
    Timer timer = new Timer.periodic(new Duration(seconds: 10), (timer) async {
      //根据用户名找到提醒
      String email = await getUserEmail();
      var url = rt.Global.serverUrl + '/queryreminder?email=' + email;
      var response =  await http.post(
        Uri.encodeFull(url),
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        }
      );
      var data = jsonDecode(response.body.toString());
      List reminderList = data['data'];
      //根据提醒类型进行不同操作
      for (var reminder in reminderList) {
        DateTime remindTime = DateTime.fromMillisecondsSinceEpoch(reminder['remindTime']);
        if (DateTime.now().compareTo(remindTime) == 1) {
          showOngoingNotification(notifications, title: "Don't forget this!", body: reminder['remindText']);
          if (reminder['repetition'] == 0) {
            url = rt.Global.serverUrl + '/dropreminder?id=' + reminder['id'];
            response = await http.post(
              Uri.encodeFull(url),
              headers: {
                "content-type" : "application/json",
                "accept" : "application/json",
              }
            );
          } else {
            url = rt.Global.serverUrl + '/updatereminder?id=' + reminder['id'];
            response = await http.post(
              Uri.encodeFull(url),
              headers: {
                "content-type" : "application/json",
                "accept" : "application/json",
              }
            );
          }
        }
        getReminder();
      }
    });
  }

  /* _decideRemind() async{
    print('decide');

  } */
}