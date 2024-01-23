import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:etapro_flutter/heading.dart';
import 'package:etapro_flutter/location.dart';
import 'package:etapro_flutter/speed.dart';
import 'package:flutter/material.dart';
import 'package:etapro_flutter/azimuth.dart';
import 'package:etapro_flutter/logger.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<StatefulWidget> createState() => SummaryState();
}

class SummaryState extends State<Summary> {
  static const int updateInterval = 10000; // ms
  var _mpsSpeed = -1;
  var _coordList = "";
  // Location location = Location();
  // Heading heading = Heading();
  // Speed speed = Speed();
  // final Azimuth _azimuth = Azimuth.none;
  // static const _className = 'SummaryState';

  // Logger is a singleton. Initializing it here gives it a few seconds to get set up before we use it
  Logger logger = Logger();

  SummaryState() : super() {
    // const String functionName = '$_className.SummaryState';
    // logger.log('$functionName: Start.');

    Timer.periodic(const Duration(milliseconds: updateInterval), getCurrentSpeed);

    // location.stream.listen((coords) {
    //   const String functionName = '$_className.SummaryState...listen';
    //   logger.log('$functionName: Start. ($coords)');

    //   if (coords[0] < 0 && coords[1] < 0) {
    //     logger.log('$functionName: Out of data. Quitting.');
    //     exit(0);
    //   }

    //   // heading.newCoordinates(coords);
    //   speed.newCoordinates(coords);
    //   logger.log('$functionName: End.');
    // });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 14, fontFamily: 'Adlam');
    final mphSpeed = (_mpsSpeed * 2.23694).round();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$_coordList',
          style: style,
        ),
        // Text(
        //   '$_mpsSpeed m/s',
        //   style: style,
        // ),
        // Text(
        //   '$mphSpeed mph',
        //   style: style,
        // ),
        // Text(
        //   'Heading: $_azimuth',
        //   style: style,
        // ),
      ],
    );
  }

  void getCurrentSpeed(Timer t) async {
    Logger logger = Logger();
    Location location = Location();

    Float64List coords = await location.GetCoords(); // Array of doubles: [0] is lat, [1] is lon
    _coordList += "$coords\n";

    logger.log("BLAM! $coords;\n$_coordList\n");

    setState(() {
      // _azimuth = heading.currentAzimuth();

      // if (!heading.changeInAzimuth()) {
      // _mpsSpeed = speed.getCurrentSpeed();
      // }
    });
  }
}
