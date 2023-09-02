import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

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
    // List<Widget> chilluns = [];
    // chilluns.add(Text('Update count: ${_updates.length}'));
    // chilluns.addAll(_updates);

    // return Column(mainAxisAlignment: MainAxisAlignment.center, children: chilluns);
    // List<Widget> child = [];
    // child.add();
    return Text(_pos.speed.toString(), style: const TextStyle(fontSize: 72, fontFamily: 'Adlam'));
    // return Row(
    //     mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: child);
    // return Column(
    //     mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: child);
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
