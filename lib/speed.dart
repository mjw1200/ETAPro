import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Speed {
  final int _updateInterval; // ms
  int _currentSpeed = -1;
  double _lastUpdateTime = 0; // last update time, in seconds-since-epoch
  double _tZero = 0; // app start time, in seconds-since-epoch

  final _platform = const MethodChannel('native_gps');
  Float64List? _currentLocation; // [0] is latitude, [1] is longitude
  String _logFileName = '';

  Speed(this._updateInterval) {
    _platform.invokeMethod('getCurrentLocation').then((value) => _currentLocation = value);
    Timer.periodic(Duration(milliseconds: _updateInterval), _updateSpeed);
    getApplicationDocumentsDirectory().then((value) => {_setLogFileName(value)});
  }

  // ----------------------------------------------------------------------------------------------
  // ...
  void _updateSpeed(Timer t) async {
    const String functionName = "_updateSpeed";

    _log('$functionName: Start');

    var newLocation = await _platform.invokeMethod('getCurrentLocation');

    // Debugging support, for now. It's possible both lat and lon could be negative IRL, but
    // I'll take that up later. Right now I need a way to stop replays at the appropriate time.
    if (newLocation[0] < 0 && newLocation[1] < 0) {
      _log('$functionName: Out of data; quitting');
      exit(0);
    }

    var distance = _haversine(_currentLocation!, newLocation);

    var now = _now();
    var elapsedTime = now - _lastUpdateTime;
    var speed = distance / elapsedTime;

    _log('$functionName: from ${_currentLocation![0]},${_currentLocation![1]}');
    _log('$functionName: to ${newLocation[0]},${newLocation[1]}');
    _log('$functionName: distance $distance m');
    _log('$functionName: time $elapsedTime s');
    _log('$functionName: speed $speed m/s (${speed * 2.23694} mph)');

    if (speed < 45) {
      // 45 m/s is 100.662 mph. Unlikely, in a standard car.
      _currentSpeed = speed.round();
    } else {
      _log('$functionName: Speed seems silly. Ignoring');
    }

    _currentLocation = newLocation;
    _lastUpdateTime = now;

    _log('$functionName: End');
  }

  // ----------------------------------------------------------------------------------------------
  // ...
  int getCurrentSpeed() {
    const String functionName = "getCurrentSpeed";
    _log('$functionName: Start. Reporting $_currentSpeed m/s (${_currentSpeed * 2.23694} mph). End.');

    return _currentSpeed;
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

  static double _now() {
    var dt = DateTime.now();
    return dt.millisecondsSinceEpoch / Duration.millisecondsPerSecond;
  }

  void _log(String message) {
    File(_logFileName).writeAsStringSync('$message\n', mode: FileMode.append);
  }

  void _setLogFileName(Directory dir) {
    _tZero = _now();
    _lastUpdateTime = _tZero;
    _logFileName = '${dir.path}/mjw_debug_$_tZero.txt';
  }
}
