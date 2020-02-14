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
  final PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  int pageIx = 0;

  @override
  void initState() {
    _getEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      timelineModel(TimelinePosition.Left),
      timelineModel(TimelinePosition.Center),
      timelineModel(TimelinePosition.Right)
    ];

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: pageIx,
            onTap: (i) => pageController.animateToPage(i,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.format_align_left),
                title: Text("LEFT"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.format_align_center),
                title: Text("CENTER"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.format_align_right),
                title: Text("RIGHT"),
              ),
            ]),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: PageView(
          onPageChanged: (i) => setState(() => pageIx = i),
          controller: pageController,
          children: pages,
        ));
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: centerTimelineBuilder,
      itemCount: rt.Global.eventData.length,
      physics: position == TimelinePosition.Left
          ? ClampingScrollPhysics()
          : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final event = rt.Global.eventData[i];
    final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
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
                Image.asset(event.eventType == 1 ? 'images/work.jpg' 
                            : (event.eventType == 2 ? 'images/sport.jpg' : 'images/relax.jpg')),
                const SizedBox(
                  height: 8.0,
                ),
                Text(event.fromTime + ' to ' + event.endTime, style: textTheme.caption),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  event.name,
                  style: textTheme.title,
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
        isLast: i == rt.Global.eventData.length,
        iconBackground: event.eventType == 1 ? Colors.cyan 
                        : (event.eventType == 2 ? Colors.redAccent : Colors.amber),
        icon: Icon(event.eventType == 1 ? Icons.work : (event.eventType == 2 ? Icons.pool : Icons.music_note)));
  }

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
          fromTimeSpecific.toIso8601String(), endTimeSpecific.toIso8601String(), 
          event['repetition'], event['eventType']
        );
        rt.Global.eventData.add(eventData);
      }
    }
    return events;
  }
}