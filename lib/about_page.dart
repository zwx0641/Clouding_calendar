import 'utils/colors.dart';
import 'utils/text_styles.dart';
import 'utils/ui_helpers.dart';
import 'widgets/sexy_tile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAboutPage extends StatefulWidget {
  @override
  _MyAboutPageState createState() => _MyAboutPageState();
}

class _MyAboutPageState extends State<MyAboutPage> {
  List<String> itemContent = [
    'What is this app about?',
    'Zalendar is a calendar application with an server deployed on the cloud.\n\nThis is a final project in my senior year and the app will be open-source once my final year ends.\n\nThis app is integrated with functionalities like reminder, events...\n\nIf you liked this app or found it helpful, please fork/star it on GitHub.\n\nThanks!',
    'Credits',
    'This app would not have been possible without the Flutter framework, the open source projects that I\'ve used and the tireless efforts of developers and contributors in the Flutter community.',
  ]; //the text in the tile

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: invertInvertColorsStrong(context),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                top: 50.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(EvaIcons.arrowIosBack),
                    tooltip: 'Go back',
                    color: invertColorsStrong(context),
                    iconSize: 26.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      'About',
                      style: isThemeCurrentlyDark(context)
                          ? TitleStylesDefault.white
                          : TitleStylesDefault.black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Hero(
                    tag: 'tile2',
                    child: SexyTile(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('images/pic1.jpg'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  EvaIcons.code,
                                  color: invertColorsMild(context),
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Text(
                                  'with',
                                  style: isThemeCurrentlyDark(context)
                                      ? BodyStylesDefault.white
                                      : BodyStylesDefault.black,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Icon(
                                  EvaIcons.heart,
                                  color: MyColors.heart,
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Text(
                                  'by',
                                  style: isThemeCurrentlyDark(context)
                                      ? BodyStylesDefault.white
                                      : BodyStylesDefault.black,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Weixuan Zeng',
                              style: isThemeCurrentlyDark(context)
                                  ? LabelStyles.white
                                  : LabelStyles.black,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    EvaIcons.person,
                                    color: invertColorsMild(context),
                                    size: 24.0,
                                  ),
                                  onPressed: () =>
                                      launchURL('https://urmilshroff.tech/'),
                                ),
                                IconButton(
                                  icon: Icon(
                                    EvaIcons.twitter,
                                    color: MyColors.twitter,
                                    size: 26.0,
                                  ),
                                  onPressed: () => launchURL(
                                      'https://twitter.com/urmilshroff'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      splashColor: MyColors.accent,
                    ),
                  ),
                  SexyTile(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            itemContent[0],
                            style: HeadingStylesDefault.accent,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            itemContent[1],
                            style: isThemeCurrentlyDark(context)
                                ? BodyStylesDefault.white
                                : BodyStylesDefault.black,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                    splashColor: MyColors.accent,
                  ),
                  SexyTile(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            itemContent[2],
                            style: HeadingStylesDefault.accent,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            itemContent[3],
                            style: isThemeCurrentlyDark(context)
                                ? BodyStylesDefault.white
                                : BodyStylesDefault.black,
                            textAlign: TextAlign.left,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
                    splashColor: MyColors.accent,
                  ),
                  SizedBox(
                    height: 36.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        child: Icon(
          EvaIcons.github,
          size: 36.0,
        ),
        tooltip: 'View GitHub repo',
        foregroundColor: invertInvertColorsStrong(context),
        backgroundColor: invertColorsStrong(context),
        elevation: 5.0,
        onPressed: () =>
            launchURL('https://github.com/zwx0641'),
      ),
    );
  }
}
