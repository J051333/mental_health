import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mental_health/helplines.dart';
import 'package:mental_health/journals.dart';
import 'package:mental_health/mh_colors.dart';
import 'package:mental_health/breathe.dart';
import 'package:mental_health/day_tracker/day_tracker_chart.dart';
import 'package:mental_health/day_tracker/mood_selection.dart';
import 'package:mental_health/day_tracker/tracker_menu.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Think',
      theme: ThemeData(
        primarySwatch: MHColors.appThemeColor,
      ),
      home: const HomePage(title: 'Take care of yourself'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  static late final Directory appDataDir;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const menuSpacing = 10.0;

  @override
  void initState() {
    setAppDataDir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColors.menuBGColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox.expand(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            // Breathe
            MenuItem("Breathe", () {
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Breathe(),
                    maintainState: false,
                  ),
                );
              });
            }),
            const SizedBox(height: menuSpacing),
            // Journals
            MenuItem("Journal", () {
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JournalList(),
                    maintainState: false,
                  ),
                );
              });
            }),
            const SizedBox(height: menuSpacing),
            // Mood Tracker
            MenuItem("Daily Mood Tracker", () {
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrackerMenu(),
                    maintainState: false,
                  ),
                );
              });
            }),
            const SizedBox(height: menuSpacing),
            // Helplines
            MenuItem(
              "Helplines",
                  () {
                Future.microtask(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelplineList(),
                      maintainState: false,
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

void setAppDataDir() async {
  HomePage.appDataDir = await getApplicationDocumentsDirectory();
  print("init");
}

class MenuItem extends StatelessWidget {
  final String _buttonText;
  final Function buttonAction;
  const MenuItem(
    this._buttonText,
    this.buttonAction, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: TextButton(
        child: Center(
          child: Text(
            _buttonText,
            style: TextStyle(
              color: MHColors.menuButtonTextColor,
              fontSize: 50,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          buttonAction();
        },
      ),
      decoration: BoxDecoration(
        color: MHColors.menuButtonColor,
        // border: Border.all(
        //   color: Colors.black12,
        //   width: 2,
        // ),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: MHColors.menuButtonShadowColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
