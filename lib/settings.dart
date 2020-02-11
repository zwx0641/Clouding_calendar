import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/appInfo.dart';
import 'routes.dart' as rt;
import 'common/Sphelper.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  
  String _colorKey;

  @override
  void initState() {
    super.initState();

    _initAsync();
  }

  _initAsync() async {
    setState(() {
      _colorKey = SpHelper.getString(rt.Global.key_theme_color, defValue: 'deepOrange');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            //选择主题
            leading: Icon(Icons.color_lens),
            title: Text('Themes'),
            initiallyExpanded: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: rt.Global.themeColorMap.keys.map((key) {
                      Color value = rt.Global.themeColorMap[key];
                      return InkWell(
                        onTap: () {
                          setState(() {
                           _colorKey = key;
                          });
                          SpHelper.putString(rt.Global.key_theme_color, key);
                          Provider.of<AppInfoProvider>(context, listen: false).setTheme(key);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          color: value,
                          child: _colorKey == key ? Icon(Icons.done, color: Colors.white,) : null,
                        ),
                      );
                    }).toList(),
                  ),
              )
            ],
          ),
          ListTile(
            //选择语言
            leading: Icon(Icons.language),
            title: Text('Multi languages'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('System default', style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                )),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          )
        ],
      ),
    );
  }
}