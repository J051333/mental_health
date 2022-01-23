import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mental_health/mh_colors.dart';

class Breathe extends StatefulWidget {
  const Breathe({Key? key}) : super(key: key);

  @override
  _BreatheState createState() => _BreatheState();
}

class _BreatheState extends State<Breathe> with SingleTickerProviderStateMixin {
  final _animationDuration = const Duration(milliseconds: 500);
  late Duration _periodicDuration;
  static const _inDur = 3500;
  static const _holdDur = 6500 + _inDur;
  static const _outDur = 7500 + _holdDur;
  static const _boxHold = 3500 + _inDur;
  static const _boxOut = 3500 + _boxHold;
  late Timer _timer;
  late Color _color;
  late String _textStr;
  late int _wait;
  late int _prevWait;
  var boxBreathing = false;
  var _elapsed = 0;

  @override
  void initState() {
    super.initState();
    _periodicDuration = const Duration(milliseconds: 10);
    _timer = Timer.periodic(_periodicDuration, (timer) => _changeColor());
    _color = Colors.pink;
    _prevWait = 0;
    _textStr = "Breathe in . . .";
    _wait = _inDur;
  }

  void _changeColor() async {
    _elapsed += 10;
    final Color newColor;

    // In reverse order to check in between absolute intervals.
    if (_elapsed >= (boxBreathing ? _boxOut : _outDur)) {
      newColor = Colors.pink;
      _elapsed = 0;
      _textStr = "Breathe in . . .";
      _prevWait = 0;
      _wait = _inDur;
    } else if (_elapsed >= (boxBreathing ? _boxHold : _holdDur)) {
      newColor = MHColors.breatheTextTwo;
      _textStr = "Breathe out . . .";
      _prevWait = boxBreathing ? _boxHold : _holdDur;
      _wait = boxBreathing ? _boxOut : _outDur;
    } else if (_elapsed >= _inDur) {
      newColor = Colors.deepPurple;
      _textStr = "Hold it . . .";
      _prevWait = _inDur;
      _wait = boxBreathing ? _boxHold : _holdDur;
    } else {
      newColor = _color;
    }

    setState(() {
      _color = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          boxBreathing = !boxBreathing;
          if (boxBreathing) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Box Breathing",
                textAlign: TextAlign.center,
              ),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "4 7 8 Breathing",
                textAlign: TextAlign.center,
              ),
            ));
          }
        },
        child: SizedBox.expand(
          child: AnimatedContainer(
            duration: _animationDuration,
            color: _color,
            child: Column(
              children: <Widget>[
                Text(
                  _textStr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: 300,
                  height: 20,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: ((_elapsed - _prevWait) / (_wait - _prevWait)),
                      color: Colors.white,
                      backgroundColor: Colors.grey,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
