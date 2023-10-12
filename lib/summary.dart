import 'dart:async';

import 'package:etapro_flutter/location.dart';
import 'package:etapro_flutter/speed.dart';
import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<StatefulWidget> createState() => SummaryState();
}

class SummaryState extends State<Summary> {
  static const int updateInterval = 30000; // ms
  Speed speed = Speed(updateInterval);
  var mpsSpeed = -2;
  Location location = Location();

  SummaryState() : super() {
    // +100: Make the display polling interval a skosh longer than the speed update interval
    Timer.periodic(const Duration(milliseconds: updateInterval + 100), getCurrentSpeed);
    location.stream.listen((coords) {
      print('Got an event! $coords');
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 24, fontFamily: 'Adlam');
    final mphSpeed = (mpsSpeed * 2.23694).round();

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
      mpsSpeed = speed.getCurrentSpeed();
    });
  }
}
