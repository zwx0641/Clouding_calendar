import 'package:shared_preferences/shared_preferences.dart';

setGlobalUserInfo(user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("userInfo", user);
}

Future<String> getGlobalUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("userInfo");
}

deleteGloabalUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("userInfo");
}

getUserLoginState() async {
  var userInfo = await getGlobalUserInfo();
  if (userInfo.length > 0 && userInfo[0] != "") {
    return true;
  } else {
    return false;
  }
}