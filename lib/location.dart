import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

const int secondsInterval = 3;

class Location {
  Float64List _currentLocation = Float64List.fromList([0.0, 0.0]); // [0] is latitude, [1] is longitude
  final _platform = const MethodChannel('native_gps');
  late Stream<Float64List> stream;

  Location() {
    Timer.periodic(const Duration(milliseconds: (secondsInterval * 1000) - 500), _updateCoords);
    stream = Stream<Float64List>.periodic(const Duration(seconds: secondsInterval), (i) => _currentLocation);
  }

  void _updateCoords(Timer t) async {
    _platform.invokeMethod('getCurrentLocation').then((value) => {_currentLocation = value});
  }
}
