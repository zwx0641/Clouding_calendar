
import 'package:clouding_calendar/userServices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


Widget header(String email) { 
    return DrawerHeader(
      padding: EdgeInsets.zero, /* padding置为0 */
      child: new Stack(children: <Widget>[ /* 用stack来放背景图片 */
        new Image.asset(
          'images/background.jpg', fit: BoxFit.fill, width: double.infinity,),
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
                    backgroundImage: AssetImage('images/pic1.jpg'),
                    radius: 35.0,
                  ),
                  onTap: getImage,
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
                          color: Colors.white),),
                      new Text("What's up", style: new TextStyle(
                          fontSize: 14.0, color: Colors.white),),
                    ],
                  ),
                ),
              ],),
          ),
        ),
      ]),
    );
}

Future getImage() async {
  if (await checkAndRequestCameraPermissions()) {
    print(1);
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image.toString());
  }
  
}

Future<bool> checkAndRequestCameraPermissions() async {
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
  if (permission != PermissionStatus.granted) {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    return permissions[PermissionGroup.camera] == PermissionStatus.granted;
  } else {
    return true;
  }
}
