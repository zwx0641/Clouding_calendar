import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart' as rt;
import 'package:http/http.dart' as http;

//设置user id
setGlobalUserInfo(user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("userInfo", user);
}

//获取user id
Future<String> getGlobalUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("userInfo");
}

deleteGloabalUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("userInfo");
}

//设置登陆状态
setUserLoginState(isLogin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isLogin", isLogin);
}

//获取登录状态
Future<bool> getUserLoginState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLogin');
}

//设置登陆状态
setUserEmail(userEmail) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("userEmail", userEmail);
}

//获取登录状态
Future<String> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userEmail');
}

//设置介绍状态
setIntroState(ifIntro) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("ifIntro", ifIntro);
}

//获取介绍状态
Future<bool> getIntroState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('ifIntro');
}

//获取提醒事件
Future<Map> getReminderEvent() async {
  String email = await getUserEmail();
  var url = rt.Global.serverUrl + '/queryreminder?email=' + email;
  var response = await http.post(
    Uri.encodeFull(url),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
    }
  );
  var data = jsonDecode(response.body.toString());
  List reminderList = data['data'];

  Map<DateTime, List> eventMap = new Map();

  if (reminderList?.isNotEmpty) {
    for (var reminder in reminderList) {
      DateTime remindTimeSpecific = DateTime.fromMillisecondsSinceEpoch(reminder['remindTime']);
      DateTime remindTime = new DateTime(remindTimeSpecific.year, remindTimeSpecific.month, 
                                        remindTimeSpecific.day);
      if (eventMap.containsKey(remindTime)) {
        eventMap[remindTime].add(reminder['remindText']);
      } else {
        List list = new List();
        list.add(reminder['remindText']);
        eventMap[remindTime] = list;
      }
    }
  }

/*   url = rt.Global.serverUrl + '/queryevent?email=' + email;
  response = await http.post(
    Uri.encodeFull(url),
    headers: {
      'content-type' : 'application/json',
      "accept" : "application/json",
    }
  );
  data = jsonDecode(response.body.toString());
  List eventList = data['data'];

  if (eventList?.isNotEmpty) {
    for (var event in eventList) {
      DateTime fromTimeSpecific = DateTime.fromMillisecondsSinceEpoch(event['fromTime']);
      DateTime fromTime = new DateTime(fromTimeSpecific.year, fromTimeSpecific.month,
                                        fromTimeSpecific.day);
      if (eventMap.containsKey(fromTime)) {
        eventMap[fromTime].add(event['eventName']);
      } else {
        List list = new List();
        list.add(event['eventName']);
        eventMap[fromTime] = list;
      }
    }
  } */
  rt.Global.events = eventMap;
  return eventMap;
}