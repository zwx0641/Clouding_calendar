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

//获取提醒事件
getReminder() async {
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
      DateTime remindTime = DateTime.fromMillisecondsSinceEpoch(reminder['remindTime']);
      if (eventMap.containsKey(remindTime)) {
        eventMap[remindTime].add(reminder['remindText']);
      } else {
        List list = new List();
        list.add(reminder['remindText']);
        eventMap[remindTime] = list;
      }
    }
  }
  

  rt.Global.events = eventMap;
}