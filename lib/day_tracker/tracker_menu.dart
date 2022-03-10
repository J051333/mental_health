import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_health/day_tracker/day_tracker_chart.dart';
import 'package:mental_health/day_tracker/mood_selection.dart';
import 'package:mental_health/journals.dart';
import 'package:mental_health/main.dart';
import 'package:mental_health/mh_colors.dart';
import 'package:path_provider/path_provider.dart';

class TrackerMenu extends StatefulWidget {
  const TrackerMenu({Key? key}) : super(key: key);

  @override
  _TrackerMenuState createState() => _TrackerMenuState();
}

class _TrackerMenuState extends State<TrackerMenu> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColors.menuBGColor,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
            Container(
              height: MediaQuery.of(context).size.height * .25,
              decoration: BoxDecoration(
                color: _isTodayRated()
                    ? MHColors.trackerMenuButtonDisabled
                    : MHColors.menuButtonColor,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: _isTodayRated()
                        ? MHColors.trackerMenuShadowDisabled
                        : MHColors.menuButtonShadowColor,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: _isTodayRated()
                    ? null
                    : () {
                        Future.microtask(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MoodSelector(),
                              maintainState: false,
                            ),
                          );
                        });
                      },
                child: Center(
                  child: Text(
                    _isTodayRated()
                        ? "You've already rated today"
                        : "How was today?",
                    style: TextStyle(
                      color: _isTodayRated()
                          ? MHColors.trackerMenuTextDisabled
                          : MHColors.menuButtonTextColor,
                      fontSize: 45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .025,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .625,
              child: const TrackerChart(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.gavel_rounded),
        onPressed: () {
          setState(() {
            File("${HomePage.appDataDir.path}/data/moods/${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}.moodent")
                .delete();
          });
        },
      ),
    );
  }

  bool _isTodayRated() {
    try {
      return File(
              "${HomePage.appDataDir.path}/data/moods/${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}.moodent")
          .existsSync();
    } catch (e) {
      print("ERROR: appDataDirectory not defined");
      return true;
    }
  }
}
