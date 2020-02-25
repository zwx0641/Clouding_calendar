import 'dart:convert';

import 'package:clouding_calendar/const/gradient_const.dart';
import 'package:clouding_calendar/eventDetails.dart';
import 'package:clouding_calendar/userServices.dart';
import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:clouding_calendar/routes.dart' as rt;
import 'package:http/http.dart' as http;
import 'model/eventData.dart';

class TimelinePage extends StatefulWidget {
  TimelinePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    //_getEvent();
    super.initState();
  }

  // Get the details of an event
  Future<List<EventData>> _getEvent() async {
    String email = await getUserEmail();
    var url = rt.Global.serverUrl + '/event/query?email=' + email;
    var response = await http.post(
      Uri.encodeFull(url),
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      }
    );
    var data = jsonDecode(response.body.toString());
    List eventList = data['data'];

    List<EventData> events = new List();
    if (eventList?.isNotEmpty) {
      for (var event in eventList) {
        DateTime fromTimeSpecific = DateTime.fromMillisecondsSinceEpoch(event['fromTime']);
        DateTime endTimeSpecific = DateTime.fromMillisecondsSinceEpoch(event['endTime']);
        EventData eventData = new EventData(
          event['id'], event['email'], event['eventName'], 
          event['location'], event['remark'], 
          fromTimeSpecific.toString(), endTimeSpecific.toString(), 
          event['repetition'], event['eventType']
        );
        rt.Global.eventData.add(eventData);
        events.add(eventData);
      }
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(fontFamily: 'Montserrat'),),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/pic01.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: FutureBuilder(
          future: _getEvent(),
          builder: (context, snap){
              if(!snap.hasData) {
                return CircularProgressIndicator();
              }
              List<EventData> events = snap.data;
              List<TimelineModel> timelines = new List();
              for (int i = 0; i < events.length; i++) {
                timelines.add(
                  TimelineModel(
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(events[i].eventType == 1 ? 'images/work.jpg' 
                                          : (events[i].eventType == 2 ? 'images/sport.jpg' 
                                          : 'images/relax.jpg')),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                events[i].fromTime + ' to ' + events[i].endTime, 
                                style: Theme.of(context).textTheme.caption
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                events[i].name,
                                style: Theme.of(context).textTheme.title,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                          onTap: () => getEventDetail(events[i].id),
                        ),
                      ),
                    ),
                    position:
                        i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
                    isFirst: i == 0,
                    isLast: i == events.length,
                    iconBackground: events[i].eventType == 1 ? Colors.cyan 
                                    : (events[i].eventType == 2 ? Colors.redAccent : Colors.amber),
                    icon: Icon(events[i].eventType == 1 ? Icons.work 
                              : (events[i].eventType == 2 ? Icons.pool : Icons.music_note)
                          )
                  )
                );
              }
              return Timeline(
                  children: timelines,
                  position: TimelinePosition.Left,
              );
            }
          ),
        ),
      );
  }

  getEventDetail(String id) async {
    var url = rt.Global.serverUrl + '/event/detail?id=' + id;
    var response =  await http.post(
      Uri.encodeFull(url),
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      }
    );
    var data = jsonDecode(response.body.toString());
    List eventList = data['data'];

    String _eventId, _eventEmail, _eventName, _location, _remark;
    DateTime _fromTime, _endTime;
    int _eventType, _repetition;

    if (eventList?.isNotEmpty) {
      for (var event in eventList) {
        _eventId = event['id'];
        _eventEmail = event['email'];
        _eventName = event['eventName'];
        _location = event['location'];
        _remark = event['remark'];
        _fromTime = DateTime.fromMillisecondsSinceEpoch(event['fromTime']);
        _endTime = DateTime.fromMillisecondsSinceEpoch(event['endTime']);
        _eventType = event['eventType'];
        _repetition = event['repetition'];
      }
    }
    
    Navigator.of(context).push(
      PageRouteBuilder<Null>(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget child) {
                return Opacity(
                  opacity: animation.value,
                  child: EventDetails(
                    _eventId, _eventEmail,
                    _eventName, _location,
                    _remark, _fromTime,
                    _endTime, _eventType, _repetition,
                  ),
                );
              });
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }
}