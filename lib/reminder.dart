import 'dart:convert';

import 'main.dart';
import 'package:clouding_calendar/userServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'routes.dart' as rt;
import 'package:http/http.dart' as http;

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 0);
  bool _switchSelected = true;
  bool _invisible = true;
  String _reminderTitle;
  List<String> _repeatArray = ['Does not repeat', 'Everyday', 'Every week', 'Every month', 'Every year'];
  String _repeatsMsg = 'Repeats';
  int _repeatTimes = 0;
  List<Widget> tiles = [];

  @override
  Widget build(BuildContext context) {
    //提醒的类型
    
    for (int i = 0; i < 5; i++) {
      //i=0为不重复，有图标
      if (i == 0) {
        tiles.add(
          new ListTile(
            leading: new Icon(Icons.replay, color: Colors.black),
            title: new Text(_repeatArray[i], style: TextStyle(color: Colors.black)),
            onTap: () {
              setState(() {
                _repeatsMsg = _repeatArray[i];
                _repeatTimes = i;
              });
            },
          ),
        );
      } else {
        //i!=0为重复，无图标
        tiles.add(
          new ListTile(
            leading: new Icon(Icons.replay, color: Colors.white),
            title: new Text(_repeatArray[i], style: TextStyle(color: Colors.black)),
            onTap: () {
              setState(() {
                _repeatsMsg = _repeatArray[i];
                _repeatTimes = i;
              });
            },
          ),
        );
      }
    }

    //提醒重复几次

    return new Scaffold(
      appBar: AppBar(
        title: new Text('Reminder'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              
              return _saveReminder();
            }
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
        child: Form(
          
          child: Column(
            children: <Widget>[
              //提醒事件的标题
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintStyle: new TextStyle(fontSize: 20),
                  hintText: 'Reminde me of ...',
                  prefixIcon: Icon(Icons.add, color: Colors.white),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _reminderTitle = value;
                  });
                },
              ),
          
              Column(
                children: <Widget>[
                  //是否全天提醒
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.query_builder),
                      Text('All day', style: TextStyle(fontSize: 18)),
                      CupertinoSwitch(
                        value: _switchSelected,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            _switchSelected = value;
                            //改变_visible，是否定时提醒
                            _invisible = value;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10, width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //时间选择器
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _showDatePicker();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(formatDate(this._selectedDate, [yyyy, '-', mm, '-', 'dd'])),
                            Icon(Icons.arrow_drop_down)
                          ],
                        ),
                      ),
                      Offstage(
                        offstage: _invisible,
                        child: InkWell(
                          onTap: () {
                            _showTimePicker();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('${this._selectedTime.format(context)}'),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 10, width: 10),
                  //提醒次数
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.replay),
                      GestureDetector(
                        child: Text(_repeatsMsg, style: TextStyle(fontSize: 18)),
                        onTap: _AddActivities
                      ),
                      IgnorePointer(
                        ignoring: true,
                        child: new Opacity(
                          opacity: 0.0,
                          child: CupertinoSwitch(
                            value: _switchSelected,
                          ),
                        )
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );

  }


  _showDatePicker() {
      //获取异步方法里面的值的第一种方式：then
      showDatePicker(
        //如下四个参数为必填参数
        context: context,
        
        initialDate: _selectedDate, //选中的日期
        firstDate: DateTime(1980), //日期选择器上可选择的最早日期
        lastDate: DateTime(2100), //日期选择器上可选择的最晚日期
      ).then((selectedValue) {
        setState(() {
          //将选中的值传递出来
          if (selectedValue != null) {
            this._selectedDate = selectedValue;
          }
        });
      }).catchError((error) {
        print(error);
      });
    }

    _showTimePicker() {
      showTimePicker(
        context: context,
        initialTime: _selectedTime
      ).then((selectedValue) {
        setState(() {
          //将选中的值传递出来
          if (selectedValue != null) {
            this._selectedTime = selectedValue;
          }
        });
      }).catchError((error) {
        print(error);
      });
    }



    // 保存提醒事件到数据库
    _saveReminder() async {
      //Record remind time
      final dt = DateTime(_selectedDate.year, _selectedDate.month, 
                          _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
      final format = new DateFormat('yyyy-MM-dd hh:mm:ss');
      
      String _remindTime = format.format(dt);
      //Which user sets the reminder
      String email = await getUserEmail();
      _remindTime = _remindTime.replaceAll(' ', 'T');
      var url = rt.Global.serverUrl + '/savereminder';
      var response = await http.post(
        Uri.encodeFull(url),
        body: json.encode({
            'email' : email,
            'remindText' : _reminderTitle,
            'remindTime' : _remindTime,
            'repetition' : _repeatTimes
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
        Navigator.popAndPushNamed(context, 'homepageRoute');
      }
    }
 
    //A sheet containing repeat selections
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
                height: 280,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: tiles  //呼出提醒列表
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
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
}

