import 'package:clouding_calendar/common/appInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'routes.dart' as rt;
import 'package:http/http.dart' as http;

Color _themeColor;
class EventDetails extends StatelessWidget {
  final String id;
  final String email;
  final String eventName;
  final String location;
  final String remark;
  final DateTime fromTime;
  final DateTime endTime;
  final int eventType;
  final int repetition;  

  //参数，提醒的id，email，内容，时间，重复类型
    EventDetails(
      this.id, 
      this.email, 
      this.eventName, 
      this.location, 
      this.remark, 
      this.fromTime, 
      this.endTime, 
      this.eventType, 
      this.repetition);



  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppInfoProvider())
      ],
      child: Consumer<AppInfoProvider>(
        builder: (context, appInfo, _) {
          String colorKey = appInfo.themeColor;
          if (rt.Global.themeColorMap[colorKey] != null) {
            _themeColor = rt.Global.themeColorMap[colorKey];
          }
          
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "Event Details",
                style: TextStyle(
                  fontFamily: 'Montserrat'
                ),
              ),
              elevation: 0.0,
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/eventbg.jpg'
                  ),
                  fit: BoxFit.fill
                )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MainSection(id: id, eventName: eventName, email: email, eventType: eventType),
                      SizedBox(
                        height: 15,
                      ),
                      ExtendedSection(
                        repetition: repetition, 
                        fromTime: fromTime,
                        endTime: endTime,
                        location: location,
                        remark: remark,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.06,
                          right: MediaQuery.of(context).size.height * 0.06,
                          top: 25,
                        ),
                        child: Container(
                          width: 280,
                          height: 70,
                          child: FlatButton(
                            color: _themeColor,
                            shape: StadiumBorder(),
                            onPressed: () {
                              deleteEvent(id);
                              Navigator.of(context).popAndPushNamed('homepageRoute');
                            },
                            child: Center(
                              child: Text(
                                "Delete Event",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat'
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  //删除一个reminder
  deleteEvent(String id) async {
    var url = rt.Global.serverUrl + '/dropevent?id=' + id;
    http.post(
      Uri.encodeFull(url),
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      }
    );
  }
}


class MainSection extends StatelessWidget {
  final String id;
  final String eventName;
  final String email;
  final int eventType;

  MainSection({
    Key key,
    @required this.id, this.eventName, this.email, this.eventType
  }) : super(key: key);

  Hero makeIcon(double size) {
    return Hero(
      tag: id + eventName,
      child: Icon(
        eventType == 1 ? Icons.work 
                              : (eventType == 2 ? Icons.pool : Icons.music_note),
        color: _themeColor,
        size: size,
      ),
    );
  }

  //右侧文字区域
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          makeIcon(175),
          SizedBox(
            width: 15,
          ),
          Column(
            children: <Widget>[
              Hero(
                tag: eventName,
                child: Material(
                  color: Colors.transparent,
                  child: MainInfoTab(
                    fieldTitle: "Event Name",
                    fieldInfo: eventName,
                  ),
                ),
              ),
              MainInfoTab(
                fieldTitle: "Setter email",
                fieldInfo: email,
              )
            ],
          )
        ],
      ),
    );
  }
}

class MainInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  MainInfoTab({Key key, @required this.fieldTitle, @required this.fieldInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 100,
      child: ListView(
        padding: EdgeInsets.only(top: 15),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            fieldTitle,
            style: TextStyle(
                fontSize: 17,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'),
          ),
          Text(
            fieldInfo,
            style: TextStyle(
                fontSize: 17,
                color: _themeColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  final int repetition;
  final String location, remark;
  final DateTime fromTime, endTime;

  const ExtendedSection({
    Key key, 
    this.repetition, 
    this.location, 
    this.remark, 
    this.fromTime, 
    this.endTime}) : super(key: key);

  //提醒间隔区域
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ExtendedInfoTab(
            fieldTitle: "Interval",
            fieldInfo: rt.Global.repeatText[repetition]
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ExtendedInfoTab(fieldTitle: 'Location', fieldInfo: location),
                flex: 2,
              ),
              Expanded(
                child: ExtendedInfoTab(fieldTitle: 'Comment', fieldInfo: remark),
                flex: 2,
              ),
            ],
          ),
          ExtendedInfoTab(
              fieldTitle: "Starts at",
              fieldInfo: fromTime.toString(),
          ),
          ExtendedInfoTab(fieldTitle: 'Ends at', fieldInfo: endTime.toString()),
        ],
      ),
    );
  }
}

//标题+信息
class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  ExtendedInfoTab(
      {Key key, @required this.fieldTitle, @required this.fieldInfo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                fieldTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: _themeColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'
                ),
              ),
            ),
            Text(
              fieldInfo,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
