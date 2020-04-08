
import 'dart:convert';
import 'package:clouding_calendar/userServices.dart';
import 'package:clouding_calendar/widgets/errorDialog.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'const/gradient_const.dart';
import 'const/styles.dart';
import 'main.dart';
import 'package:clouding_calendar/routes.dart' as rt;
import 'package:http/http.dart' as http;

 

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  String _email, _password, _hintMessage = 'default';
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
                fit: BoxFit.contain,
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
            'Don\'t have an account?',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, 'signupRoute');
            },
            child: Text(
              'Sign Up',
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
            hintText: 'Password',
            hintStyle: hintAndValueStyle),
          onChanged: (value) => _password = value,
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
        decoration: new InputDecoration(
            suffixIcon: Icon(IconData(0xe902, fontFamily: 'Icons'),
                color: Color(0xff35AA90), size: 10.0),
            contentPadding: new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(12.0),
                borderSide: BorderSide.none),
            hintText: 'Email',
            hintStyle: hintAndValueStyle),
        onChanged: (value) => _email = value,
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
            'WELCOME TO ZALENDAR!',
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
              'Log in \nto continue.',
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
              var emailReg = RegExp(
              r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
              if (!emailReg.hasMatch(_email)) {
                return _showErrorDialog('Caution', 'Incorrect email form');
              }
              if (_email.isEmpty || _password.isEmpty) {
                return _showErrorDialog('Caution', 'Please complete all fields');
              }
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
                'LOGIN',
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
    var url = rt.Global.serverUrl + '/login';
    var response = await http.post(
      Uri.encodeFull(url),
      body: json.encode({
        'password': _password,
        'email': _email
      }), headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      }
    );
    var data = jsonDecode(response.body.toString());
    _hintMessage = data['msg'];
    _code = data['status'];

    if (_code == 200) {
      var user = data['data'];
              
      // Save id to local cache
      setGlobalUserInfo(user['id']);
      setUserEmail(user['email']);
      setUserToken(user['userToken']);
      setUserLoginState(true);
      Fluttertoast.showToast(
        msg: 'Logging you in...',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        
      );
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
        builder: (BuildContext buildContext) {
          return MyHomePage();
        }
      ), (route) => route == null);
      
    } else {
      return _showErrorDialog('Error', _hintMessage);
    }
  }

  Future<Widget> _showErrorDialog(String title, String msg) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ErrorDialog(title: title, message: msg);
      }
    );
  }
}
