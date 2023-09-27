import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Speed {
  final int _updateInterval; // ms
  final int _sampleSize;
  int _lastUpdateTime = 0; // last update time, in seconds-since-epoch
  int _tZero = 0; // app start time, in seconds-since-epoch

  final _platform = const MethodChannel('native_gps');
  late Directory appDocumentsDir;
  Float64List? _currentLocation; // [0] is latitude, [1] is longitude
  String _logFileName = '';
  final _speeds = []; // speeds are averaged

  Speed(this._updateInterval, this._sampleSize) {
    _platform.invokeMethod('getCurrentLocation').then((value) => _currentLocation = value);
    Timer.periodic(Duration(milliseconds: _updateInterval), _updateSpeed);
    getApplicationDocumentsDirectory().then((value) => {_setLogFileName(value)});
  }

  // ----------------------------------------------------------------------------------------------
  // Read a "raw" speed, and handle it appropriately
  void _updateSpeed(Timer t) async {
    _log('_updateSpeed: Start');

    var now = _now();
    var elapsedTime = now - _lastUpdateTime;

    var newLocation = await _platform.invokeMethod('getCurrentLocation');
    var distance = _haversine(_currentLocation!, newLocation);

    if (newLocation[0] < 0 && newLocation[1] < 0) {
      _log('_updateSpeed: Out of data; quitting');
      exit(0);
    }

    var speed = distance / elapsedTime;
    _log(
        '_updateSpeed: lat1,${_currentLocation![0]},lon1,${_currentLocation![1]},lat2,${newLocation[0]},lon2,${newLocation[1]},dist,$distance,time,$elapsedTime,speed,$speed');

    if (speed < 45 && speed >= 1) {
      // Constrain values. 45 m/s is 100.662 mph, and zeroes fuck up the average
      _addASpeed(speed.round());
    } else {
      _log('_updateSpeed: Speed out of range, ignoring');
    }

    _currentLocation = newLocation;
    _lastUpdateTime = now;

    _log('_updateSpeed: End');
  }

  // ----------------------------------------------------------------------------------------------
  // Add a speed to the collection. Remove the oldest speed if that gives us more speeds than we
  // want
  void _addASpeed(int speed) {
    _log('_addASpeed: Start');

    _speeds.add(speed);

    if (_speeds.length > _sampleSize) {
      _log('_addASpeed: Removing oldest speed sample');
      _speeds.removeAt(0);
    }

    // DEBUG
    String debugSpeeds = "";
    for (var element in _speeds) {
      debugSpeeds += "$element,";
    }

    _log('_addASpeed: End $debugSpeeds');
  }

  // ----------------------------------------------------------------------------------------------
  // Average the accumulated speeds. Return -1 if we don't have enough samples yet.
  int getMostRecentSpeed() {
    _log('getMostRecentSpeed: Start');

    if (_speeds.length < _sampleSize) {
      _log('getMostRecentSpeed: Not enough speeds. Have ${_speeds.length}, need $_sampleSize');
      return -1;
    }

    int total = 0;

    for (final speed in _speeds) {
      total += speed as int;
    }

    var speed = (total / _sampleSize).round();

    _log('getMostRecentSpeed: End ($speed) m/s');
    return speed;
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

  static int _now() {
    var dt = DateTime.now();
    return (dt.millisecondsSinceEpoch / Duration.millisecondsPerSecond).round();
  }

  void _log(String message) {
    File(_logFileName).writeAsStringSync('$message\n', mode: FileMode.append);
  }

  void _setLogFileName(Directory dir) {
    appDocumentsDir = dir;
    _tZero = _now();
    _lastUpdateTime = _tZero;
    _logFileName = '${appDocumentsDir.path}/mjw_debug_$_tZero.txt';
  }
}
