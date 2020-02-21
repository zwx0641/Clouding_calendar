
import 'dart:convert';
import 'dart:io';

import 'package:clouding_calendar/userServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:clouding_calendar/routes.dart' as rt;


Widget header(String email, String faceImage) {
    String faceUrl = rt.Global.serverUrl + faceImage; 
    return DrawerHeader(
      padding: EdgeInsets.zero, /* padding置为0 */
      child: new Stack(children: <Widget>[ /* Use stack to display background image */
        
        new Image.asset('images/pic1.jpg', fit: BoxFit.fill, width: double.infinity,),
        new Align(/* 先放置对齐 */
          alignment: FractionalOffset.bottomLeft,
          child: Container(
            height: 70.0,
            margin: EdgeInsets.only(left: 12.0, bottom: 12.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min, /* 宽度只用包住子组件即可 */
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: faceUrl != null ? NetworkImage(faceUrl) :
                                      AssetImage('images/pic1.jpg'),
                    radius: 35.0,
                  ),
                  onTap: () {
                    getImage();
                  },
                ),
                new Container(
                  margin: EdgeInsets.only(left: 6.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 水平方向左对齐
                    mainAxisAlignment: MainAxisAlignment.center, // 竖直方向居中
                    children: <Widget>[
                      new Text(email, style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'Montserrat'),),
                      new Text("What's up", style: new TextStyle(
                          fontSize: 14.0, color: Colors.black,
                          fontFamily: 'Montserrat'),),
                    ],
                  ),
                ),
              ],),
          ),
        ),
      ]),
    );
}

// Upload avatar
Future getImage() async {
  try {
    String userId = await getGlobalUserInfo();
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var uploadURL = rt.Global.serverUrl + '/user/uploadFace?userId=' + userId;

    if (image != null) {
      var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
      var length = await image.length();

      var uri = Uri.parse(uploadURL);

      // Upload file
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
            filename: basename(image.path));
            //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();

      String _responseString;
      
      // Parse returned string to json
      var _responseJson = jsonDecode(_responseString);
      

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Upload successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER
        );
      } else if (response.statusCode == 500) {
        Fluttertoast.showToast(
          msg: _responseJson['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER
        );
      }
    }
  } catch (e) {}
}
