import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mental_health/breathe.dart';
import 'package:mental_health/mh_colors.dart';

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
        primarySwatch: MHColors.menuButtonColor,
      ),
      home: const HomePage(title: 'Take care of yourself'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const menuSpacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox.expand(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            MenuItem("Breathe", () {
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Breathe()),
                );
              });
            }),
            const SizedBox(height: menuSpacing),
            MenuItem("Journal", () {}),
            const SizedBox(height: menuSpacing),
            MenuItem("Helplines", () {}),
            const SizedBox(height: menuSpacing),
            MenuItem("???", () {}),
          ],
        ),
      ),
    );
  }
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          ),
        ),
        onPressed: () => buttonAction(),
      ),
      decoration: BoxDecoration(
        color: Colors.black45,
        border: Border.all(
          color: Colors.black12,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
