import 'dart:convert';

import 'package:clouding_calendar/main.dart';
import 'package:clouding_calendar/userServices.dart';
import 'package:clouding_calendar/widgets/errorDialog.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'const/color_const.dart';
import 'const/gradient_const.dart';
import 'const/size_const.dart';
import 'widget/signup_apbar.dart';
import 'widget/signup_arrow_button.dart';
import 'package:clouding_calendar/routes.dart' as rt;
import 'package:http/http.dart' as http;

class ReminderPage extends StatefulWidget {
  final String id;
  final String remindText;
  final DateTime remindTime;
  final int repetition;
  final String email;

  const ReminderPage({Key key, this.id, this.remindText, this.remindTime, this.repetition, this.email}) : super(key: key);
  

  _ReminderPageState createState() => _ReminderPageState(
    id, remindText, remindTime, repetition, email
  );
}

class _ReminderPageState extends State<ReminderPage> {
  // Parameters
  final String id;
  final String remindText;
  final DateTime remindTime;
  final int repetition;
  final String email;



  // Initialization
  String _currentDate = 'Select Date';
  String _currentTime = 'Select Time';
  DateTime _selectedDate;
  String _remindText;
  TimeOfDay _selectedTime = new TimeOfDay(hour: 0, minute: 00);
  List _repeatArray = ["Does not repeat", "Everyday", "Every week", "Every month", "Every year"];
  String _currentRepeat = "Does not repeat";
  int _repetition = 0;
  TextEditingController _controller = TextEditingController();
  bool _switchSelected = false;
  bool _invisible = false;

  _ReminderPageState(this.id, this.remindText, this.remindTime, this.repetition, this.email);

  void changeDropDownLocationItem(String selectedRepeat) {
    setState(() {
      _currentRepeat = selectedRepeat;
      _repetition = _repeatArray.indexOf(selectedRepeat);
    });
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate == null ? DateTime.now() : _selectedDate,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2050));
    if (picked != null)
      setState(() {
        _currentDate = formatDate(picked, [yyyy, '-', mm, '-', 'dd']);
        _selectedDate = picked;
      });
    print(_remindText);
  }

  Future _selectTime() async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay(hour: 0, minute: 00),
    );
    if (picked != null) {
      setState(() {
        _currentTime = '${picked.format(context)}';
        _selectedTime = picked;
      });
    }
  }

  @override
  void initState() { 
    super.initState();
    if (_repeatArray[repetition] != null) {
      _currentRepeat = _repeatArray[repetition];
    } 
    
    Future.delayed(Duration.zero, () {
      _remindText = remindText;
      _repetition = repetition;
      _selectedDate = remindTime;
      _selectedTime = TimeOfDay(hour: remindTime.hour, minute: remindTime.minute);
      _repetition = repetition;
    
    });
  }

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;


    return Scaffold(
      appBar: SignupApbar(
        title: "CREATE REMINDER",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
              height: _media.height,
              width: _media.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/signup_page_11_bg.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                SignUpArrowButton(
                  height: 70,
                  width: 70,
                  icon: IconData(0xe903, fontFamily: 'Icons'),
                  iconSize: 30,
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 40,
                ),
                fieldColorBox(
                    SIGNUP_BACKGROUND, "REMINDER NAME", _controller, remindText),
                dateColorBox(
                    SIGNUP_BACKGROUND, "TIME", _currentDate, _selectDate, _currentTime, _selectTime),
                shadowColorBox(
                    SIGNUP_CARD_BACKGROUND, "ALL DAY"),
                Wrap(children: <Widget>[
                locationColorBox(
                      SIGNUP_BACKGROUND, "REPEAT TYPE", _currentRepeat),
                ]),
                
                SizedBox(
                  height: 30,
                ),
                nexButton("Confirm"),
              ],
            ),
          ],
        ),
      ),
    );
  }

    // A dialog showing errors
  Future<Widget> _showErrorDialog(String title, String msg) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ErrorDialog(title: title, message: msg);
      }
    );
  }

  Widget locationColorBox(
      Gradient gradient, String title, String currentLocation) {
    

    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30,
        bottom: 8,
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 30,
              offset: Offset(1.0, 9.0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(fontSize: TEXT_SMALL_SIZE, color: Colors.grey, fontFamily: 'Montserrat'),
              ),
            ),
            Expanded(
              flex: 2,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Montserrat'
                  ),
                  isExpanded: true,
                  onChanged: changeDropDownLocationItem,
                  items: _repeatArray.map((items) {
                    return DropdownMenuItem<String>(
                      value: items,
                      child: Text(
                        items,
                      ),
                    );
                  }).toList(),
                  value: currentLocation,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shadowColorBox(
      Gradient gradient, String title) {
    
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30,
        bottom: 8,
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 30,
              offset: Offset(1.0, 9.0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(fontSize: TEXT_SMALL_SIZE, color: Colors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Wrap(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  CupertinoSwitch(
                    value: _switchSelected,
                    activeColor: Color(0xffabecd6),
                    onChanged: (value) {
                      setState(() {
                        _switchSelected = value;
                        // Change _visible(Set remind time)
                        _invisible = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldColorBox(Gradient gradient, String title,
      TextEditingController controller, String remindText) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30,
        bottom: 8,
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 30,
              offset: Offset(1.0, 9.0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(fontSize: TEXT_SMALL_SIZE, color: Colors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Wrap(
                children: <Widget>[
                  TextFormField(
                    //controller: controller,
                    initialValue: remindText,
                    style: TextStyle(fontFamily: 'Montserrat'),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: TEXT_NORMAL_SIZE, color: Colors.black)),
                    onChanged: (value) {
                      setState(() {
                        _remindText = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dateColorBox(
      Gradient gradient, String title, 
      String date, Function dateFunction, 
      String time, Function timeFunction) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30,
        bottom: 8,
      ),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(fontSize: TEXT_SMALL_SIZE, color: Colors.grey, fontFamily: 'Montserrat'),
              ),
            ),
            Expanded(
              flex: 2,
              child: Wrap(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      date == 'Select Date' ? formatDate(remindTime, [yyyy, '-', mm, '-', 'dd']) : date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat'
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: dateFunction,
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: _invisible,
              child: FlatButton(
                child: Text(
                  remindTime.hour == 0 && remindTime.minute == 0 && remindTime.second == 0 ? 
                  time : '${TimeOfDay(hour: remindTime.hour, minute: remindTime.minute).format(context)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat'
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: timeFunction,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nexButton(String text) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        height: 45,
        width: 120,
        decoration: BoxDecoration(
          gradient: SIGNUP_CIRCLE_BUTTON_BACKGROUND,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: YELLOW,
            fontWeight: FontWeight.w700,
            fontSize: TEXT_NORMAL_SIZE,
            fontFamily: 'Montserrat'
          ),
        ),
      ),
      onTap: () {
        if (_remindText == null) {
          _showErrorDialog('Caution', 'Please enter reminder name');
        } else if (_selectedDate == null) {
          _showErrorDialog('Caution', 'Please when to remind you');
        } else {
          return _saveReminder();
        }
      },
    );
  }

  // Save to database
  _saveReminder() async {
    //Record remind time
    final dt = DateTime(_selectedDate.year, _selectedDate.month, 
                        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    final format = new DateFormat('yyyy-MM-dd HH:mm:ss');
    
    String _remindTime = format.format(dt);
    //Which user sets the reminder
    String email = await getUserEmail();
    _remindTime = _remindTime.replaceAll(' ', 'T');
    var url = rt.Global.serverUrl + '/reminder/save';
    var response = await http.post(
      Uri.encodeFull(url),
      body: json.encode({
          'id' : id,
          'email' : email,
          'remindText' : _remindText,
          'remindTime' : _remindTime,
          'repetition' : _repetition
        }
      ),
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      }
    );
    var data = jsonDecode(response.body.toString());
    var code = data['status'];
    if (code != 200) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(height: 15),
                  Text('Failed to set a reminder', style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Confirm', style: TextStyle(color: Colors.white),),
                onPressed: () {},
                color: Colors.blueGrey,
              )
            ],
          );
        }
      );
    } else {
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
        builder: (BuildContext buildContext) {
          return MyHomePage();
        }
      ), (route) => route == null);
    }
  }
}
