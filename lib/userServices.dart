import 'package:shared_preferences/shared_preferences.dart';

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