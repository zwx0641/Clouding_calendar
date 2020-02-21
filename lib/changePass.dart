
import 'dart:convert';
import 'package:clouding_calendar/signin.dart';
import 'package:clouding_calendar/userServices.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'const/gradient_const.dart';
import 'const/styles.dart';
import 'main.dart';
import 'package:clouding_calendar/routes.dart' as rt;
import 'package:http/http.dart' as http;

 

class ChangePassPage extends StatefulWidget {
  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  String _formerPass, _newPass, _hintMessage = 'default';
  int _code;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 64.0),
        decoration: BoxDecoration(gradient: SIGNUP_BACKGROUND),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Center(
              child: Image.asset(
                'images/logo_signup.png',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
            headlinesWidget(),
            emailTextFieldWidget(),
            passwordTextFieldWidget(),
            loginButtonWidget(),
            signupWidget()
          ],
        ),
      ),
    );
  }


  Widget signupWidget() {
    return Container(
      margin: EdgeInsets.only(left: 48.0, top: 32.0),
      child: Row(
        children: <Widget>[
          Text(
            'Forgot your password?',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, 'signupRoute');
            },
            child: Text(
              'Click Me',
              style: TextStyle(
                  color: Color(0xff353535),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
          )
        ],
      ),
    );
  }

  Widget passwordTextFieldWidget() {
    return Container(
      margin: EdgeInsets.only(left: 32.0, right: 16.0),
      child: TextField(
        style: hintAndValueStyle,
        obscureText: true,
        decoration: new InputDecoration(
            fillColor: Color(0x3305756D),
            filled: true,
            contentPadding: new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(12.0),
                borderSide: BorderSide.none),
            hintText: 'New Password',
            hintStyle: hintAndValueStyle),
          onChanged: (value) => _newPass = value,
      ),
    );
  }

  Widget emailTextFieldWidget() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 32.0, top: 32.0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                spreadRadius: 0,
                offset: Offset(0.0, 16.0)),
          ],
          borderRadius: new BorderRadius.circular(12.0),
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.4),
              end: FractionalOffset(0.9, 0.7),
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [
                0.2,
                0.9
              ],
              colors: [
                Color(0xffFFC3A0),
                Color(0xffFFAFBD),
              ])),
      child: TextFormField(
        style: hintAndValueStyle,
        obscureText: true,
        decoration: new InputDecoration(
            suffixIcon: Icon(IconData(0xe902, fontFamily: 'Icons'),
                color: Color(0xff35AA90), size: 10.0),
            contentPadding: new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(12.0),
                borderSide: BorderSide.none),
            hintText: 'Former Password',
            hintStyle: hintAndValueStyle),
        onChanged: (value) => _formerPass = value,
      ),
    );
  }

  Widget headlinesWidget() {
    return Container(
      margin: EdgeInsets.only(left: 48.0, top: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'WELCOME BACK!',
            textAlign: TextAlign.left,
            style: TextStyle(
                letterSpacing: 3,
                fontSize: 20.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 48.0),
            child: Text(
              'Reset \nyour password.',
              textAlign: TextAlign.left,
              style: TextStyle(
                letterSpacing: 3,
                fontSize: 32.0,
                fontFamily: 'Montserrat',
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget loginButtonWidget() {
    return Container(
      margin: EdgeInsets.only(left: 32.0, top: 32.0),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              sendPost();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        spreadRadius: 0,
                        offset: Offset(0.0, 32.0)),
                  ],
                  borderRadius: new BorderRadius.circular(36.0),
                  gradient: LinearGradient(begin: FractionalOffset.centerLeft,
  // Add one stop for each color. Stops should increase from 0 to 1
                      stops: [
                        0.2,
                        1
                      ], colors: [
                    Color(0xff000000),
                    Color(0xff434343),
                  ])),
              child: Text(
                'RESET',
                style: TextStyle(
                    color: Color(0xffF1EA94),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Login方法，与后端交互
  Future<Widget> sendPost() async {
    String userId = await getGlobalUserInfo();
    var url = rt.Global.serverUrl + '/user/passchange?userId=' + userId 
              + '&formerPass=' + _formerPass + '&newPass=' + _newPass;
    var response = await http.post(
      Uri.encodeFull(url),
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      }
    );
    var data = jsonDecode(response.body.toString());
    _hintMessage = data['msg'];
    _code = data['status'];

    if (_code == 200) {
      
      Fluttertoast.showToast(
        msg: 'Success',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        
      );
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
        builder: (BuildContext buildContext) {
          logout();
          return SigninPage();
        }
      ), (route) => route == null);
      
    } else if (_code == 404) {
      return _showErrorWidget('Server Error');
    } else {
      return _showErrorWidget(_hintMessage);
    }
  }

  logout() async {
    // Get local cache
    var userId = await getGlobalUserInfo();
    var url = rt.Global.serverUrl + '/logout?userId=' + userId; 
    // Delete redis cache
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
      // Delete local cache
      deleteGloabalUserInfo();
      // Set user state as logout
      setUserLoginState(false);
      Navigator.popAndPushNamed(context, 'signinRoute');
    }
  }

  Future<Widget> _showErrorWidget(String msg) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 15),
                Text(msg, style: TextStyle(fontSize: 17),),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Confirm', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
                },
              color: Colors.blueGrey,
            )
          ],
        );
      }
    );
  }
}
