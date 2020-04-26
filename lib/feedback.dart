import 'package:clouding_calendar/userServices.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FeedbackPage extends StatefulWidget {
  final String title;

  const FeedbackPage({Key key, @required this.title}) : super(key: key);
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String _emailBody;

  @override
  void initState() {
    super.initState();
  }

  //图片，文字，输入框，按钮
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: () {Navigator.pop(context);}
        ),
        title: Text(widget.title, style: TextStyle(fontFamily: 'Montserrat'),),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              widget.title == 'Feedbacks' ? 'images/pic02.png' : 'images/pic09.png'
            ),
            fit: BoxFit.fill
          )
        ),
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: AppTheme.nearlyWhite,
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top,
                          left: 16,
                          right: 16),
                      child: new Image.asset(widget.title == 'Feedbacks' 
                      ? 'images/feedbackImage.png' : 'images/help.png'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.title == 'Feedbacks' ? 'Your feedbacks' : 'How can I help you?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: const Text(
                        'Give your best time for this moment.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat'
                        ),
                      ),
                    ),
                    _buildComposer(widget.title),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  offset: const Offset(4, 4),
                                  blurRadius: 8.0),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                _sendEmail();
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Send',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComposer(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                maxLines: null,
                onChanged: (String txt) {
                  _emailBody = txt;
                },
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: AppTheme.dark_grey,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: title == 'Feebacks' ? 'Enter your feedback...' 
                              : 'Anything you want to ask...'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //点击发送反馈，然后打开邮件app写邮件
  _sendEmail() async {
    String _feedbacker = await getUserEmail();

    final Email email = Email(
      body: _emailBody,
      subject: 'Feedback and help from ' + _feedbacker,
      recipients: ['zwx0641@outlook.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);

    Fluttertoast.showToast(
      msg: 'Thank you for your feedbacks',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
}
