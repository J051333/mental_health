import 'package:flutter/material.dart';
import 'package:mental_health/mh_colors.dart';

class Breathe extends StatefulWidget {
  const Breathe({Key? key}) : super(key: key);

  @override
  _BreatheState createState() => _BreatheState();
}

class _BreatheState extends State<Breathe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
           child: Text("pop"),
        ),
        decoration: const BoxDecoration(
          color: Colors.green,
        ),
      )
    );
  }
}
