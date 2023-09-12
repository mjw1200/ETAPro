import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_routes/google_maps_routes.dart';
// import 'package:geolocator/geolocator.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<StatefulWidget> createState() => LocationState();
}

class LocationState extends State<Location> {
  static const platform = MethodChannel('native_gps');

  final int _updateInterval = 5000; // ms
  // double _speed = 0.001; // ensure non-zero
  Float64List _location = Float64List.fromList([88.88, 99.99]);
  List<Widget> _chilluns = [];

  LocationState() : super() {
    Timer.periodic(Duration(milliseconds: _updateInterval), periodicUpdate);
  }

  @override
  Widget build(BuildContext context) {
    // var mphSpeed = (_speed * 2.23694).round();

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: _chilluns // [
        // Text(
        //   'Speed (mph): ${mphSpeed.toStringAsFixed(0)}',
        //   style: style,
        // ),
        //   Text(
        //     'Lat: ${_location[0]} / Lon: ${_location[1]}',
        //     style: style,
        //   ),
        // ],
        );
  }

  void periodicUpdate(Timer t) async {
    // Music Villa: 45.67973305878354, -111.02897198805852
    // The Office: 45.660500254366056, -110.55933360340568
    // Touchmark: 46.57686096725291, -111.98913545917074
    const TextStyle style = TextStyle(fontSize: 18, fontFamily: 'Adlam');

    try {
      Float64List location = await platform.invokeMethod('getCurrentLocation');

      setState(() {
        _location = location;

        _chilluns.add(Text(
          'Lat: ${_location[0]} / Lon: ${_location[1]}',
          style: style,
        ));
      });
    } on PlatformException catch (e) {
      stderr.write('Caught a PlatformException in periodicUpdate: ${e.message}');
    }
  }
}
