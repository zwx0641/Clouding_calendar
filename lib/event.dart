import 'package:clouding_calendar/main.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String _eventName;
String _location;
DateTime _selectedFromDate;
TimeOfDay _selectedFromTime;
DateTime _selectedEndDate;
TimeOfDay _selectedEndTime;
int _repetition;

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  TextEditingController nameController;
  TextEditingController dosageController;
 
  bool _is0Selected = false;
  bool _is1Selected = false;
  bool _is2Selected = false;
  bool _is3Selected = false;
  bool _is4Selected = false;

  GlobalKey<ScaffoldState> _scaffoldKey;

  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
  }

  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _selectedFromDate = DateTime.now();
    _selectedFromTime = TimeOfDay(hour: 0, minute: 00);
    _selectedEndDate = DateTime.now();
    _selectedEndTime = TimeOfDay(hour: 0, minute: 00);
    _repetition = -1;
  }

  // 判断哪种重复被选择
  void _handle0Changed(bool value) {
    setState(() {
      if (_is1Selected || _is2Selected || _is3Selected || _is4Selected) {
        _is1Selected = _is2Selected = _is3Selected = _is4Selected = false;
        _is0Selected = true;
        _repetition = 0;
      } else {
        _is0Selected = value;
        if (!value) {_repetition = -1;} else {_repetition = 0;}
      }
    });
  }
  void _handle1Changed(bool value) {
    setState(() {
      if (_is0Selected || _is2Selected || _is3Selected || _is4Selected) {
        _is0Selected = _is2Selected = _is3Selected = _is4Selected = false;
        _is1Selected = true;
        _repetition = 1;
      } else {
        _is1Selected = value;
        if (!value) {_repetition = -1;} else {_repetition = 1;}
      }
    });
  }
  void _handle2Changed(bool value) {
    setState(() {
      if (_is1Selected || _is0Selected || _is3Selected || _is4Selected) {
        _is1Selected = _is0Selected = _is3Selected = _is4Selected = false;
        _is2Selected = true;
        _repetition = 2;
      } else {
        _is2Selected = value;
        if (!value) {_repetition = -1;} else {_repetition = 2;}
      }
    });
  }
  void _handle3Changed(bool value) {
    setState(() {
      if (_is1Selected || _is2Selected || _is0Selected || _is4Selected) {
        _is1Selected = _is2Selected = _is0Selected = _is4Selected = false;
        _is3Selected = true;
        _repetition = 3;
      } else {
        _is3Selected = value;
        if (!value) {_repetition = -1;} else {_repetition = 3;}
      }
    });
  }
  void _handle4Changed(bool value) {
    setState(() {
      if (_is1Selected || _is2Selected || _is3Selected || _is0Selected) {
        _is1Selected = _is2Selected = _is3Selected = _is0Selected = false;
        _is4Selected = true;
        _repetition = 4;
      } else {
        _is4Selected = value;
        if (!value) {_repetition = -1;} else {_repetition = 4;}
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          "Add New Mediminder",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Provider.value(
          
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 25,
            ),
            children: <Widget>[
              PanelTitle(
                title: "Event Name",
                isRequired: true,
              ),
              TextFormField(
                maxLength: 12,
                style: TextStyle(
                  fontSize: 16,
                ),
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _eventName = value;
                  });
                },
              ),
              PanelTitle(
                title: "Location",
                isRequired: false,
              ),
              TextFormField(
                controller: dosageController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontSize: 16,
                ),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _location = value;
                  });
                },
              ),
              SizedBox(
                height: 15,
              ),

              PanelTitle(
                title: "Repeat Type",
                isRequired: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: StreamBuilder(
                  
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RepeatTypeColumn(
                            type: 0,
                            name: "No repeat",
                            iconValue: Icons.timer_off,
                            isSelected: _is0Selected,
                            onChanged: _handle0Changed,
                        ),
                        RepeatTypeColumn(
                            type: 1,
                            name: "Daily",
                            iconValue: Icons.loop,
                            isSelected: _is1Selected,
                            onChanged: _handle1Changed,
                        ),
                        RepeatTypeColumn(
                            type: 2,
                            name: "Weekly",
                            iconValue: Icons.view_array,
                            isSelected: _is2Selected,
                            onChanged: _handle2Changed,
                        ),
                        RepeatTypeColumn(
                            type: 3,
                            name: "Monthly",
                            iconValue: Icons.view_week,
                            isSelected: _is3Selected,
                            onChanged: _handle3Changed,
                        ),
                        RepeatTypeColumn(
                            type: 4,
                            name: "Yearly",
                            iconValue: Icons.timelapse,
                            isSelected: _is4Selected,
                            onChanged: _handle4Changed,
                        ),
                      ],
                    );
                  },
                ),
              ),
              PanelTitle(
                title: "Starting Time",
                isRequired: true,
              ),
              SelectDateTime(type: 1),
              PanelTitle(
                title: "Ending Time",
                isRequired: true,
              ),
              SelectDateTime(type: 2),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.10,
                  right: MediaQuery.of(context).size.height * 0.10,
                ),
                child: Container(
                  width: 200,
                  height: 60,
                  child: FlatButton(
                    color: Colors.purple[100],
                    shape: StadiumBorder(),
                    child: Center(
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    onPressed: () {
                      
                      //--------------------Error Checking------------------------
                      //Had to do error checking in UI
                      //Due to unoptimized BLoC value-grabbing architecture
                   
                      //---------------------------------------------------------
                      if (_eventName == null) {
                        showErrorWidget('Please enter event name');
                      } else if (_repetition == -1) {
                        showErrorWidget('Please select whether to repeat');
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return MyHomePage();
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ), value: null,
        ),
      ),
    );
  }

  Future<Widget> showErrorWidget(String hintMsg) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 15),
                Text(hintMsg, style: TextStyle(fontSize: 17),),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Confirm', style: TextStyle(color: Colors.white),),
              onPressed: () {Navigator.of(context).pop(); },
              color: Colors.blueGrey,
            )
          ],
        );
      }
    );
  }

}

class SelectDateTime extends StatefulWidget {
  final int type;
  @override
  _SelectDateTimeState createState() => _SelectDateTimeState(type: type);

  /**
   * type 1: From
   * type 2: End
   */
  SelectDateTime({Key key, @required this.type}) : super (key: key);
}

class _SelectDateTimeState extends State<SelectDateTime> {
  final int type;

  _SelectDateTimeState({Key key, @required this.type});

  bool _dateClicked = false;
  bool _timeClicked = false;

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate, firstDate: DateTime(1970), lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateClicked = true;
        if (type == 1) {
          _selectedFromDate = picked;
        } else if (type == 2) {
          _selectedEndDate = picked;
        }
      });
    }
    return picked;
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedFromTime,
    );
    if (picked != null) {
      setState(() {
        if (type == 1) {
          _selectedFromTime = picked;
        } else if (type == 2) {
          _selectedEndTime = picked;
        }
        _timeClicked = true;
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              color: Colors.purple[100],
              shape: StadiumBorder(),
              onPressed: () {
                _selectDate(context);
              },
              child: Center(
                child: Text(
                  _dateClicked == false
                      ? "Pick Date"
                      : formatDate(
                        type == 1 ? _selectedFromDate 
                                  : _selectedEndDate, [yyyy, '-', mm, '-', 'dd']
                        ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            FlatButton(
              color: Colors.purple[100],
              shape: StadiumBorder(),
              onPressed: () {
                _selectTime(context);
              },
              child: Center(
                child: Text(
                  _timeClicked == false
                      ? "Pick Time"
                      : type == 1 ? '${_selectedFromTime.format(context)}' 
                                  : '${_selectedEndTime.format(context)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


//重复图标和文字
class RepeatTypeColumn extends StatelessWidget {
  final String name;
  final IconData iconValue;
  final bool isSelected;
  final int type;
  final ValueChanged<bool> onChanged;

  RepeatTypeColumn(
      {Key key,
      @required this.type,
      @required this.name,
      @required this.iconValue,
      @required this.isSelected,
      @required this.onChanged,
      })
      : super(key: key);

  void _selectedChanged() {
    onChanged(!isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //呈现改变
      onTap: () {
        _selectedChanged();
      },
      child: Column(
        children: <Widget>[
          Container(
            width: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.purple[100] : Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 14.0),
                child: Icon(
                  iconValue,
                  size: 58,
                  color: isSelected ? Colors.white : Colors.purple[100],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              width: 63,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? Colors.purple[100] : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.purple[100],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  final String title;
  final bool isRequired;
  PanelTitle({
    Key key,
    @required this.title,
    @required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 4),
      child: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: isRequired ? " *" : "",
            style: TextStyle(fontSize: 14, color: Colors.purple[100]),
          ),
        ]),
      ),
    );
  }
}
