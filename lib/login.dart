import 'dart:convert';

import 'package:clouding_calendar/custom_router.dart';
import 'package:clouding_calendar/register.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:http/http.dart' as http;
import 'routes.dart' as rt;
import 'userServices.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _hintMessage = 'default';
  var data;
  int _code;
  bool _isObscure = true;
  Color _eyeColor = Colors.black;
  List _loginMethod = [
    {
      'title': 'facebook',
      'icon': GroovinMaterialIcons.facebook,
    },
    {
      'title': 'google',
      'icon': GroovinMaterialIcons.google,
    },
    {
      'title': 'twitter',
      'icon': GroovinMaterialIcons.twitter,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight,
            ),
            buildTitle(),
            buildTitleLine(),
            SizedBox(height: 70.0,),
            buildEmailTextField(),
            SizedBox(height: 30.0,),
            buildPasswordTextField(context),
            buildForgetPasswordText(context),
            SizedBox(height: 60.0,),
            buildLoginButton(context),
            SizedBox(height: 30.0,),
            buildOtherLoginText(),
            buildOtherMethod(context),
            buildRegisterText(context)
          ],
        ),
      ),
    );
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('No account?'),
            GestureDetector(
              child: Text('Click to register', style: TextStyle(color: Colors.green),),
              onTap: () {
                print('去注册');
                Navigator.push(context, new CustomRoute(RegisterPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod.map((item) => Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(item['icon'], color: Colors.black),
            onPressed: () {
              Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text('${item['title']}Login'),
                  action: new SnackBarAction(
                    label: 'Cancel',
                    onPressed: () {},
                  ),
                )
              );
            },
          );
        },
      )).toList(),
    );
  }

  Align buildOtherLoginText() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Use another account',
        style: TextStyle(color: Colors.grey, fontSize: 14.0),
      ),
    );
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          color: Colors.black,
          onPressed: () {
          
            //执行登陆方法
            return sendPost();
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text('Forget your password?', style: TextStyle(fontSize: 14.0, color: Colors.grey),),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
     return TextFormField(
       onChanged: (String value) => _password = value,
       obscureText: _isObscure,
       validator: (String value) {
         if (value.isEmpty) {
           return 'Please enter your password';
         }
       },
       decoration: InputDecoration(
         labelText: 'Password',
         suffixIcon: IconButton(
           icon: Icon(Icons.remove_red_eye, color: _eyeColor,),
           onPressed: () {
             setState(() {
              _isObscure = !_isObscure;
              _eyeColor = _isObscure ? Colors.grey : Theme.of(context).iconTheme.color; 
             });
           },
         )
       ),
     );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email address',
      ),
      validator: (String value) {
        var emailReg = RegExp(
           r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?"
        );
        if (!emailReg.hasMatch(value)) {
          return 'Please enter the correct email address!';
        }
      },
      onChanged: (String value) => _email = value,
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 12.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Login', style: TextStyle(fontSize: 42.0, color: Colors.black),
      ),
    );
  }

  
  //Login方法，与后端交互
  Future<Widget> sendPost() async {
    var url = rt.serverUrl + '/login';
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
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 15),
                Text(_hintMessage, style: TextStyle(fontSize: 20),),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Confirm', style: TextStyle(color: Colors.white),),
              onPressed: () {
                if (_code == 200) {
                  var user = data['data'];
             
                  //存id到本地储存
                  setGlobalUserInfo(user['id']);
                  Navigator.popAndPushNamed(context, 'homepageRoute');
                } else {
                  Navigator.of(context).pop();
                  }
                },
              color: Colors.blueGrey,
            )
          ],
        );
      }
    );
  }
}

