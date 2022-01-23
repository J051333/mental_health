import 'package:flutter/material.dart';

class HelplineList extends StatelessWidget {
  const HelplineList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Helplines"),),
      body: SizedBox.expand(
        child: ListView(

        ),
      ),
    );
  }
}

class HelplineItem extends StatelessWidget {
  const HelplineItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

