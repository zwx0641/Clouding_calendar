import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'routes.dart' as rt;
import 'package:http/http.dart' as http;

class MedicineDetails extends StatelessWidget {
  final String id;
  final String remindText;
  final DateTime remindTime;
  final int repetition;
  final String email;

  MedicineDetails(this.id, this.email, this.remindText, this.remindTime, this.repetition);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.deepOrange,
        ),
        centerTitle: true,
        title: Text(
          "Reminder Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MainSection(id: id, remindText: remindText, email: email),
              SizedBox(
                height: 15,
              ),
              ExtendedSection(repetition: repetition, remindTime: remindTime,),
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
                    color: Colors.deepOrange,
                    shape: StadiumBorder(),
                    onPressed: () {
                      deleteReminder(id);
                      Navigator.of(context).popAndPushNamed('homepageRoute');
                    },
                    child: Center(
                      child: Text(
                        "Delete Reminder",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
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
    );
  }

  deleteReminder(String id) async {
    var url = rt.Global.serverUrl + '/dropreminder?id=' + id;
    var response = await http.post(
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
  final String remindText;
  final String email;

  MainSection({
    Key key,
    @required this.id, this.remindText, this.email
  }) : super(key: key);

  Hero makeIcon(double size) {
    return Hero(
      tag: id + remindText,
      child: Icon(
        Icons.alarm,
        color: Colors.deepOrange,
        size: size,
      ),
    );
  }

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
                tag: remindText,
                child: Material(
                  color: Colors.transparent,
                  child: MainInfoTab(
                    fieldTitle: "Reminder Name",
                    fieldInfo: remindText,
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
                color: Color(0xFFC9C9C9),
                fontWeight: FontWeight.bold),
          ),
          Text(
            fieldInfo,
            style: TextStyle(
                fontSize: 17,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  final int repetition;
  final DateTime remindTime;

  ExtendedSection({Key key, @required this.repetition, this.remindTime}) : super(key: key);


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
          ExtendedInfoTab(
              fieldTitle: "Remind Time",
              fieldInfo: remindTime.toString(),
          )
        ],
      ),
    );
  }
}

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
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              fieldInfo,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFC9C9C9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
