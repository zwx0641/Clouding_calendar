import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Send feedbacks'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}