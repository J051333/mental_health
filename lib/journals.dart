import 'package:flutter/material.dart';

import 'mh_colors.dart';

class JournalList extends StatelessWidget {
  const JournalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MHColors.menuBGColor,
      appBar: AppBar(
        title: const Text("widget.title"),
      ),
      body: SizedBox.expand(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
