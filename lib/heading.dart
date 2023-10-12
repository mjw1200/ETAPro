import 'dart:typed_data';
import 'dart:math';

enum Azimuth { none, north, northEast, east, southeast, south, southwest, west, northwest }

class Heading {
  Float64List? _current; // [0] is latitude (φ), [1] is longitude (λ)
  Float64List? _last;
  Azimuth _lastAzimuth = Azimuth.none;

  final degToRad = pi / 180;
  final radToDeg = 180 / pi;

  bool azimuthChange(double lat, double lon) {
    bool verdict = false;

    // 1. Move _current to _last; set _current
    _set(lat, lon);

    // 2. Calculate the azimuth from _last and _current
    var newAzimuth = _calculate();

    // 3. Compare it to the last known heading
    // 4. Return true if different; false if the same
    if (newAzimuth == Azimuth.none || newAzimuth != _lastAzimuth) {
      verdict = true;
    }

    _lastAzimuth = newAzimuth;

    return verdict;
  }

  void _set(double lat, double lon) {
    _last = _current;
    _current = Float64List.fromList([lat, lon]);
  }

  Azimuth _calculate() {
    if (_last == null || _current == null) {
      return Azimuth.none;
    }

    final t1 = _last![0] * degToRad; // this would be φ1, except I can't use Greek letters
    final l1 = _last![1] * degToRad; // this would be λ1, except...
    final t2 = _current![0] * degToRad;
    final l2 = _current![1] * degToRad;
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

    if (degrees > 337.5 && degrees < 22.5) {
      return Azimuth.north;
    } else if (degrees > 22.5 && degrees < 67.5) {
      return Azimuth.northEast;
    } else if (degrees > 67.5 && degrees < 112.5) {
      return Azimuth.east;
    } else if (degrees > 112.5 && degrees < 157.5) {
      return Azimuth.southeast;
    } else if (degrees > 157.5 && degrees < 202.5) {
      return Azimuth.south;
    } else if (degrees > 202.5 && degrees < 247.5) {
      return Azimuth.southwest;
    } else if (degrees > 247.5 && degrees < 292.5) {
      return Azimuth.west;
    } else {
      return Azimuth.northwest;
    }
  }
}
