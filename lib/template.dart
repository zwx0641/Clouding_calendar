import 'package:flutter/material.dart';

Widget header = DrawerHeader(
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
            new CircleAvatar(
              backgroundImage: AssetImage('images/pic1.jpg'),
              radius: 35.0,),
            new Container(
              margin: EdgeInsets.only(left: 6.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 水平方向左对齐
                mainAxisAlignment: MainAxisAlignment.center, // 竖直方向居中
                children: <Widget>[
                  new Text('username', style: new TextStyle(
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
  ]),);
