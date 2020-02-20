import 'dart:convert';

import 'package:clouding_calendar/userServices.dart';
import 'package:flutter/material.dart';
import 'widget/signup_apbar.dart';
import 'const/gradient_const.dart';
import 'const/styles.dart';
import 'widget/signup_profile_image_picker.dart';
import 'package:clouding_calendar/routes.dart' as rt;
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _email, _password, _repeatPassword, _username;
  String _hintMessage;
  int _code;

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: SignupApbar(
        title: "Sign Up",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              statusbarHeight,
          decoration: BoxDecoration(gradient: SIGNUP_BACKGROUND),
          child: Align(
            alignment: Alignment.topCenter,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: 80.0, left: 48.0, right: 48.0, bottom: 48.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            spreadRadius: 0,
                            offset: Offset(0.0, 32.0)),
                      ],
                      borderRadius: BorderRadius.circular(16.0),
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
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 180.0, left: 24.0, right: 24.0, bottom: 16.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        textField('NAME', false, 0),
                        textField('EMAIL', false, 1),
                        textField('PASSWORD', true, 2),
                        textField('REPEAT PASS', true, 3),
                        Padding(
                          padding: const EdgeInsets.only(top: 36.0),
                        )
                      ],
                    ),
                  ),
                ),
                ProfileImagePicker(
                    margin:
                        EdgeInsets.only(left: 32.0, right: 72.0, top: 56.0)),
                Positioned(
                  bottom: 16.0,
                  right: 18.9,
                  child: signupButton('NEXT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField textField(String labelText, bool obscureText, int which) {
    return TextField(
      style: hintAndValueStyle,
      obscureText: obscureText,
      decoration: new InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color: Color(0xff353535),
              fontWeight: FontWeight.normal,
              fontSize: 18.0)),
      onChanged: (value) {
        switch (which) {
          case 0:
            _username = value;
            break;
          case 1:
            _email = value;
            break;
          case 2:
            _password = value;
            break;
          case 3:
            _repeatPassword = value;
            break;
          default:
        }
      },
    );
  }

  Widget signupButton(title) {
    return InkWell(
      onTap: () {
        if (_password != _repeatPassword) {
          return _showErrorWidget('Inconsistent passwords');
        }
        return sendPost();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 18.0),
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
          title,
          style: TextStyle(
              color: Color(0xffF1EA94),
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
        ),
      ),
    );
  }

    // Registration, uses POST
  Future<Widget> sendPost() async {
    var url = rt.Global.serverUrl + '/register';
    var response = await http.post(
      Uri.encodeFull(url),
      body: json.encode({
        'username': _username,
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
    // Whether successful
    if (_code == 200) {
      var user = data['data'];
      setGlobalUserInfo(user['id']);
      // Set user state as login
      setUserLoginState(true);
      Navigator.popAndPushNamed(context, 'signinRoute');
    } else {
      return _showErrorWidget(_hintMessage);
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
                Text(msg, style: TextStyle(fontSize: 20),),
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

