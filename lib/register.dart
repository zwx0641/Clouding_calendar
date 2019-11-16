import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _repeatPassword, _username;
  String _hintMessage;
  int _code;
  var data;


  bool _isObscure = true;
  Color _eyeColor = Colors.black;
  List _registerMethod = [
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
            SizedBox(height: 50.0,),
            buildEmailTextField(),
            SizedBox(height: 25.0,),
            buildUsernameTextField(),
            SizedBox(height: 25.0,),
            buildPasswordTextField(context, 1),
            SizedBox(height: 25.0,),
            buildPasswordTextField(context, 2),
            SizedBox(height: 55.0,),
            buildRegisterButton(context),
            SizedBox(height: 30.0,),
            buildOtherRegisterText(),
            buildOtherMethod(context),
          ],
        ),
      ),
    );
  }


  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _registerMethod.map((item) => Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(item['icon'], color: Colors.black),
            onPressed: () {
              Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text('${item['title']}Register'),
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

  Align buildOtherRegisterText() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Use another account',
        style: TextStyle(color: Colors.grey, fontSize: 14.0),
      ),
    );
  }

  Align buildRegisterButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          color: Colors.black,
          onPressed: () {
            /* if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              //TODO:执行登陆方法
            } */
            _getRegister();
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
                            Navigator.popAndPushNamed(context, 'loginRoute');
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
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  //type:密码框的种类（1输入密码，2重复密码）
  TextFormField buildPasswordTextField(BuildContext context, int type) {
     return TextFormField(
       onChanged: (String value) {
         if (type == 1) {
          _password = value;
         } else if (type == 2) {
           _repeatPassword = value;
         }
       },
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

  TextFormField buildUsernameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Username',
      ),
      onChanged: (String value) => _username = value,
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
        'Register', style: TextStyle(fontSize: 42.0, color: Colors.black),
      ),
    );
  }

  //注册方法，后端交互
  _getRegister() async {
    var url = 'http://172.17.95.177:8080/user/uregister?email=$_email&password=$_password&password2=$_repeatPassword&username=$_username';
    var httpClient = new HttpClient();

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        data = jsonDecode(json);
        _hintMessage = data['msg'];
        _code = data['code'];
      } else {
        print('error');
      }
    } catch (exception) {
      _hintMessage = 'Failed getting IP address';
    }
  }
}

