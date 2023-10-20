import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:etapro_flutter/logger.dart';
import 'package:etapro_flutter/time.dart';

class Speed {
  double _lastUpdateTime = 0; // last update time, in seconds-since-epoch
  Float64List? _currentLocation; // [0] is latitude, [1] is longitude
  Float64List? _previousLocation;
  int _currentSpeed = -1;
  Logger logger = Logger();
  static const _className = 'Speed';

  // ----------------------------------------------------------------------------------------------
  // ...
  void newCoordinates(Float64List coords) {
    _previousLocation = _currentLocation;
    _currentLocation = coords;

    _calculate();
  }

  // ----------------------------------------------------------------------------------------------
  // ...
  int getCurrentSpeed() {
    const String functionName = '$_className.getCurrentSpeed';
    logger.log('$functionName: Start. Reporting $_currentSpeed m/s (${_currentSpeed * 2.23694} mph). End.');

    return _currentSpeed;
  }

  // ----------------------------------------------------------------------------------------------
  // ...
  void _calculate() async {
    const String functionName = '$_className._calculate';

    logger.log('$functionName: Start');

    // Debugging support, for now. It's possible both lat and lon could be negative IRL, but
    // I'll take that up later. Right now I need a way to stop replays at the appropriate time.
    if (_currentLocation![0] < 0 && _currentLocation![1] < 0) {
      logger.log('$functionName: Out of data; quitting');
      exit(0);
    } else if (_previousLocation == null) {
      logger.log('$functionName: No previous location yet');
      return;
    }

    var distance = _haversine(_previousLocation!, _currentLocation!);

    var now = Time().secondsSinceEpoch();
    var elapsedTime = now - _lastUpdateTime;
    var speed = distance / elapsedTime;

    logger.log('$functionName: from ${_previousLocation![0]},${_previousLocation![1]}');
    logger.log('$functionName: to ${_currentLocation![0]},${_currentLocation![1]}');
    logger.log('$functionName: distance $distance m');
    logger.log('$functionName: time $elapsedTime s');
    logger.log('$functionName: speed $speed m/s (${speed * 2.23694} mph)');

    if (speed < 45) {
      // 45 m/s is 100.662 mph. Unlikely, in a standard car.
      _currentSpeed = speed.round();
    } else {
      logger.log('$functionName: Speed seems silly; ignoring.');
    }

    _lastUpdateTime = now;

    logger.log('$functionName: End');
  }

  // ----------------------------------------------------------------------------------------------
  // Calculate the Haversine formula (https://en.wikipedia.org/wiki/Haversine_formula) to find the
  // distance between two lat/lon points. Phi is latitude, lambda is longitude, and no - I can't
  // use the symbols φ and λ, much as I'd like to do. Inputs are in degrees, and the returned
  // distance is in meters.
  double _haversine(Float64List p1, Float64List p2) {
    const double earthRadius = 6.371e6; // meters
    const double radiansPerDegree = 0.01745;

    if (p1.isEmpty || p2.isEmpty) {
      return 0.0;
    }

    double phi1 = p1[0] * radiansPerDegree;
    double lambda1 = p1[1] * radiansPerDegree;
    double phi2 = p2[0] * radiansPerDegree;
    double lambda2 = p2[1] * radiansPerDegree;

    double deltaLam = lambda2 - lambda1;
    double deltaPhi = phi2 - phi1;

    double sin2Phi = pow(sin(deltaPhi / 2), 2) as double;
    double sin2Lam = pow(sin(deltaLam / 2), 2) as double;

    return 2 * earthRadius * asin(sqrt(sin2Phi + cos(phi1) * cos(phi2) * sin2Lam));
  }
}
