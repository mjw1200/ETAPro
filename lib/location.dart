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
  List<Text> _updates = [];
  var quackCount = 1;

  LocationState() : super() {
    Timer.periodic(const Duration(milliseconds: 5000), setCurrentPosition);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chilluns = [];
    chilluns.add(Text('Update count: ${_updates.length}'));
    chilluns.addAll(_updates);

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: chilluns);
  }

  void setCurrentPosition(Timer t) async {
    setState(() {});

    log('Quack ${this.quackCount++}');
    var pos = await _geolocatorPlatform.getCurrentPosition();
    _updates.add(Text('Lat: ${pos.latitude} Lon: ${pos.longitude} Speed: ${pos.speed} Time: ${pos.timestamp}'));
  }
}
