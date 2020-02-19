import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'routes.dart' as rt;
import 'userServices.dart';

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
      child: GestureDetector(
        child: Text(
          'Use another account',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
        onTap: () {Navigator.popAndPushNamed(context, 'loginPage');},
      )
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
            if (_repeatPassword != _password) {
              return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          SizedBox(height: 15),
                          Text('Inconsistent passwords', style: TextStyle(fontSize: 17),),
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
            //执行登陆方法
            return sendPost();
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  //type of password textfield（1 password，2 repeat password）
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
         labelText: type == 1 ? 'Password' : 'Repeat your password',
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
    data = jsonDecode(response.body.toString());
    _hintMessage = data['msg'];
    _code = data['status'];
    // Whether successful
    if (_code == 200) {
      var user = data['data'];
      setGlobalUserInfo(user['id']);
      // Set user state as login
      setUserLoginState(true);
      Navigator.popAndPushNamed(context, 'loginRoute');
    }
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

