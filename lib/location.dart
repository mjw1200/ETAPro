import 'dart:async';
// import 'dart:ffi';
import 'dart:io';
import 'dart:math';
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

    double dist = _haversine(45.6530606, -110.5638456, 45.6539567, -110.564763);

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

  // ----------------------------------------------------------------------------------------------
  // Calculate the Haversine formula (https://en.wikipedia.org/wiki/Haversine_formula) to find the
  // distance between two lat/lon points. Phi is latitude, lambda is longitude, and no - I can't
  // use the symbols φ and λ, much as I'd like to do. Inputs are in degrees, and the returned dist-
  // ance is in meters.
  double _haversine(double phi1Deg, double lambda1Deg, double phi2Deg, double lambda2Deg) {
    const double earthRadius = 6.371e6; // meters
    const double toRadians = 0.01745;

    double phi1 = phi1Deg * toRadians;
    double lambda1 = lambda1Deg * toRadians;
    double phi2 = phi2Deg * toRadians;
    double lambda2 = lambda2Deg * toRadians;

    double deltaLam = lambda2 - lambda1;
    double deltaPhi = phi2 - phi1;

    double sin2Phi = pow(sin(deltaPhi / 2), 2) as double;
    double sin2Lam = pow(sin(deltaLam / 2), 2) as double;

    return 2 * earthRadius * asin(sqrt(sin2Phi + cos(phi1) * cos(phi2) * sin2Lam));
  }
}
