import 'dart:typed_data';
import 'dart:math';

import 'package:etapro_flutter/azimuth.dart';
import 'package:etapro_flutter/logger.dart';

class Heading {
  Float64List? _currentLocation; // [0] is latitude (φ), [1] is longitude (λ)
  Float64List? _lastLocation;
  Azimuth _currentAzimuth = Azimuth.none;
  Azimuth _previousAzimuth = Azimuth.none;
  static const _className = 'Speed';
  Logger logger = Logger();

  final degToRad = pi / 180;
  final radToDeg = 180 / pi;

  // ----------------------------------------------------------------------------------------------
  // ...
  void newCoordinates(Float64List coords) {
    const String functionName = '$_className.newCoordinates';
    logger.log('$functionName: Start. $coords');

    _lastLocation = _currentLocation;
    _currentLocation = coords;
    _calculate();

    logger.log('$functionName: End.');
  }

  // ----------------------------------------------------------------------------------------------
  // ...
  bool changeInAzimuth() {
    const String functionName = '$_className.changeInAzimuth';
    logger.log('$functionName: Start.');

    var change = false;

    if (_currentAzimuth == Azimuth.none || _previousAzimuth == Azimuth.none || _currentAzimuth != _previousAzimuth) {
      logger.log('$functionName: Reporting change $_previousAzimuth --> $_currentAzimuth');
      change = true;
    }

    logger.log('$functionName: End.');
    return change;
  }

  // ----------------------------------------------------------------------------------------------
  // ...
  Azimuth currentAzimuth() {
    const String functionName = '$_className.changeInAzimuth';
    logger.log('$functionName: Start. $_currentAzimuth');
    logger.log('$functionName: End.');

    return _currentAzimuth;
  }

  // ----------------------------------------------------------------------------------------------
  // See https://www.omnicalculator.com/other/azimuth#azimuth-formula
  void _calculate() {
    if (_lastLocation == null || _currentLocation == null) {
      return;
    }

    final t1 = _lastLocation![0] * degToRad; // this would be φ1, except I can't use Greek letters
    final l1 = _lastLocation![1] * degToRad; // this would be λ1, except...
    final t2 = _currentLocation![0] * degToRad;
    final l2 = _currentLocation![1] * degToRad;
    final dl = l2 - l1; // this would be Δλ, except...

    final radians = atan2(sin(dl) * cos(t2), cos(t1) * sin(t2) - sin(t1) * cos(t2) * cos(dl));
    final degrees = (radians * radToDeg + 360) % 360;

    // North	337.5	22.5
    // Northeast	22.5	67.5
    // East	67.5	112.5
    // Southeast	112.5	157.5
    // South	157.5	202.5
    // Southwest	202.5	247.5
    // West	247.5	292.5
    // Northwest	292.5	337.5

    _previousAzimuth = _currentAzimuth;

    if (degrees > 337.5 && degrees < 22.5) {
      _currentAzimuth = Azimuth.north;
    } else if (degrees > 22.5 && degrees < 67.5) {
      _currentAzimuth = Azimuth.northEast;
    } else if (degrees > 67.5 && degrees < 112.5) {
      _currentAzimuth = Azimuth.east;
    } else if (degrees > 112.5 && degrees < 157.5) {
      _currentAzimuth = Azimuth.southeast;
    } else if (degrees > 157.5 && degrees < 202.5) {
      _currentAzimuth = Azimuth.south;
    } else if (degrees > 202.5 && degrees < 247.5) {
      _currentAzimuth = Azimuth.southwest;
    } else if (degrees > 247.5 && degrees < 292.5) {
      _currentAzimuth = Azimuth.west;
    } else {
      _currentAzimuth = Azimuth.northwest;
    }
  }
}
