import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'mood.dart';
import 'package:mental_health/mh_colors.dart';

class MoodSelector extends StatefulWidget {
  const MoodSelector({Key? key}) : super(key: key);

  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  int value = 5;
  late Directory appDataDir;
  static const int faceWidthFactor = 7;

  @override
  void initState() {
    _setAppDataDir();
    super.initState();
  }

  String _valueDemonText(int v) {
    String valueRating;

    try {
      valueRating = Mood.moodsList[v];
    } catch (e) {
      valueRating = "Invalid rating, you shouldn't ever see this";
    }

    return valueRating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColors.menuBGColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_dissatisfied_rounded,
                size: 75,
                color: MHColors.menuButtonTextColor,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / faceWidthFactor,
              ),
              Icon(
                Icons.sentiment_neutral_rounded,
                size: 75,
                color: MHColors.menuButtonTextColor,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / faceWidthFactor,
              ),
              Icon(
                Icons.sentiment_very_satisfied_rounded,
                size: 75,
                color: MHColors.menuButtonTextColor,
              ),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: 0,
            max: 10,
            activeColor: MHColors.selectorActiveColor,
            inactiveColor: MHColors.selectorInactiveColor,
            onChanged: (double newValue) {
              if (value != newValue.round()) {
                HapticFeedback.lightImpact();
              }
              setState(() {
                value = newValue.round();
              });
            },
          ),
          Text(
            _valueDemonText(value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MHColors.menuButtonTextColor,
              fontSize: 50,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {_writeMood(value);},
        child: Icon(
          Icons.check_rounded,
          color: MHColors.menuButtonTextColor,
        ),
      ),
    );
  }

  void _writeMood(int mood) {
    Directory moodDir = Directory('${appDataDir.path}/data/moods');
    if (moodDir.existsSync()) {
      String moodFileName = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}.moodent";
      File newMoodEntry = File("$moodDir/$moodFileName");
      newMoodEntry.writeAsString("$mood");
      Navigator.pop(context);
    } else {
      print(moodDir.toString());
      moodDir.createSync(recursive: true);
      _writeMood(mood);
    }
  }

  void _setAppDataDir() async {
    appDataDir = await getApplicationDocumentsDirectory();
  }
}
