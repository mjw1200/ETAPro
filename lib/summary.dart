import 'dart:async';

import 'package:etapro_flutter/speed.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<StatefulWidget> createState() => SummaryState();
}

class SummaryState extends State<Summary> {
  static const int updateInterval = 15000;
  Speed speed = Speed(updateInterval);
  var mpsSpeed = -2;

  SummaryState() : super() {
    Timer.periodic(const Duration(milliseconds: updateInterval + 50), getCurrentSpeed);
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 24, fontFamily: 'Adlam');
    const mpsToMph = 2.23694;

    var mphSpeed = (mpsSpeed * mpsToMph).round();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$mpsSpeed m/s',
          style: style,
        ),
        Text(
          '$mphSpeed mph',
          style: style,
        ),
      ],
    );
  }

  void getCurrentSpeed(Timer t) async {
    setState(() {
      mpsSpeed = speed.getMostRecentSpeed();
    });
  }
}
