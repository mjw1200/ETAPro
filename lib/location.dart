import 'dart:async';
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
  static const _platform = MethodChannel('native_gps');
  static const _updateInterval = 5000; // ms
  static const _minimumMeters = 100;

  int _lastEpochSeconds = 0;
  int _speed = 0; // m/s
  int _updateCount = 0;
  int _lastDist = 0;

  Float64List _lastLocation = Float64List.fromList([]);

  LocationState() : super() {
    Timer.periodic(const Duration(milliseconds: _updateInterval), updateLocation);
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 24, fontFamily: 'Adlam');
    const mpsToMph = 2.23694;

    int mphSpeed = 0;

    mphSpeed = (_speed * mpsToMph).round();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$_updateCount updates',
          style: style,
        ),
        Text(
          '$_lastDist m',
          style: style,
        ),
        Text(
          '$_speed m/s',
          style: style,
        ),
        Text(
          '$mphSpeed mph',
          style: style,
        ),
      ],
    );
  }

  void updateLocation(Timer t) async {
    // Music Villa: 45.67973305878354, -111.02897198805852
    // The Office: 45.660500254366056, -110.55933360340568
    // Touchmark: 46.57686096725291, -111.98913545917074

    double dist = 0.0;

    try {
      Float64List newLocation = await _platform.invokeMethod('getCurrentLocation');

      dist = _haversine(_lastLocation, newLocation);

      if (_lastLocation.isEmpty) {
        _lastLocation = newLocation;
      } else if (dist > _minimumMeters) {
        var currentEpochSeconds = (DateTime.now().millisecondsSinceEpoch / Duration.millisecondsPerSecond).round();
        var elapsedSeconds = currentEpochSeconds - _lastEpochSeconds;

        setState(() {
          _speed = (dist / elapsedSeconds).round();
          _lastEpochSeconds = currentEpochSeconds;
          _lastLocation = newLocation;
          _lastDist = dist.round();
          _updateCount++;
        });
      }
    } on PlatformException catch (e) {
      stderr.write('Caught a PlatformException in periodicUpdate: ${e.message}');
    }
  }

  // ----------------------------------------------------------------------------------------------
  // Calculate the Haversine formula (https://en.wikipedia.org/wiki/Haversine_formula) to find the
  // distance between two lat/lon points. Phi is latitude, lambda is longitude, and no - I can't
  // use the symbols φ and λ, much as I'd like to do. Inputs are in degrees, and the returned
  // distance is in meters.
  double _haversine(Float64List p1, Float64List p2) {
    const double earthRadius = 6.371e6; // meters
    const double toRadians = 0.01745;

    if (p1.isEmpty || p2.isEmpty) {
      return 0.0;
    }

    double phi1 = p1[0] * toRadians;
    double lambda1 = p1[1] * toRadians;
    double phi2 = p2[0] * toRadians;
    double lambda2 = p2[1] * toRadians;

    double deltaLam = lambda2 - lambda1;
    double deltaPhi = phi2 - phi1;

    double sin2Phi = pow(sin(deltaPhi / 2), 2) as double;
    double sin2Lam = pow(sin(deltaLam / 2), 2) as double;

    return 2 * earthRadius * asin(sqrt(sin2Phi + cos(phi1) * cos(phi2) * sin2Lam));
  }
}
