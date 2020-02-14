import 'dart:convert';

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

  //得到event的内容
  Future<List<EventData>> _getEvent() async {
    String email = await getUserEmail();
    var url = rt.Global.serverUrl + '/queryevent?email=' + email;
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
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: _getEvent(),
          builder: (context, snap){
              if(!snap.hasData) {
                return CircularProgressIndicator();
              }
              List<EventData> events = snap.data;
              List<TimelineModel> timelines = new List();
              for (int i = 0; i < events.length; i++) {
                print(i);
                timelines.add(
                  TimelineModel(
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
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
      );
  }
}