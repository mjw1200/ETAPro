import 'dart:async';

import 'package:etapro_flutter/heading.dart';
import 'package:etapro_flutter/location.dart';
import 'package:etapro_flutter/speed.dart';
import 'package:flutter/material.dart';
import 'package:etapro_flutter/azimuth.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<StatefulWidget> createState() => SummaryState();
}

class SummaryState extends State<Summary> {
  static const int updateInterval = 30000; // ms
  var _mpsSpeed = -1;
  Location location = Location();
  Heading heading = Heading();
  Speed speed = Speed();
  Azimuth _azimuth = Azimuth.none;

  SummaryState() : super() {
    // +100: Make the display polling interval a skosh longer than the speed update interval
    Timer.periodic(const Duration(milliseconds: updateInterval + 100), getCurrentSpeed);

    location.stream.listen((coords) {
      heading.newCoordinates(coords);
      speed.newCoordinates(coords);
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 24, fontFamily: 'Adlam');
    final mphSpeed = (_mpsSpeed * 2.23694).round();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Text(
        //   '$_mpsSpeed m/s',
        //   style: style,
        // ),
        // Text(
        //   '$mphSpeed mph',
        //   style: style,
        // ),
        Text(
          'Heading: $_azimuth',
          style: style,
        ),
      ],
    );
  }

  void getCurrentSpeed(Timer t) async {
    setState(() {
      if (heading.changeInAzimuth()) {
        _azimuth = heading.currentAzimuth();
      } else {
        _mpsSpeed = speed.getCurrentSpeed();
      }
    });
  }
}
