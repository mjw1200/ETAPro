import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<StatefulWidget> createState() => LocationState();
}

class LocationState extends State<Location> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  Position _pos = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  LocationState() : super() {
    Timer.periodic(const Duration(milliseconds: 5000), setCurrentPosition);
  }

  @override
  Widget build(BuildContext context) {
    // format('{}', 'hello world')
    return Text(format('{:.0f}', _pos.speed), style: const TextStyle(fontSize: 72, fontFamily: 'Adlam'));
  }

  void setCurrentPosition(Timer t) async {
    var pos = await _geolocatorPlatform.getCurrentPosition();
    _pos = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: pos.speed * 2.237, // convert speed from m/s to mph
        speedAccuracy: 0);

    setState(() {});
  }
}
