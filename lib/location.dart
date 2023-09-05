import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:geolocator/geolocator.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<StatefulWidget> createState() => LocationState();
}

class LocationState extends State<Location> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final int _updateInterval = 5000; // ms
  double _lat = 0.0;
  double _lon = 0.0;
  double _speed = 0.001; // ensure non-zero
  double _dist = 0.0;

  LocationState() : super() {
    Timer.periodic(Duration(milliseconds: _updateInterval), setCurrentPosition);
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 22);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Lat: $_lat',
          style: style,
        ),
        Text(
          'Lon: $_lon',
          style: style,
        ),
        Text(
          'Speed (m/s): $_speed',
          style: style,
        ),
        Text(
          'Dist remain (m): $_dist',
          style: style,
        ),
        Text(
          'Time remain (s): ${_dist / _speed}',
          style: style,
        )
      ],
    );
  }

  void setCurrentPosition(Timer t) async {
    // Music Villa: 45.67973305878354, -111.02897198805852
    // The Office: 45.660500254366056, -110.55933360340568
    // 'AIzaSyDklNhepabAAhzB_iX5jhVfIiTCU6cHfPo'

    // TODO: How stable is geolocator? Should we use a Google service instead?
    var currentPosition = await _geolocatorPlatform.getCurrentPosition();
    _lon = currentPosition.longitude;
    _lat = currentPosition.latitude;
    _speed = currentPosition.speed + 0.001; // ensure non-zero

    /// LatLng is included in google_maps_flutter
    List<LatLng> points = [
      LatLng(_lat, _lon), // where you am
      const LatLng(45.67973305878354, -111.02897198805852), // Music Villa
    ];

    DistanceCalculator distanceCalculator = DistanceCalculator();
    var distString = distanceCalculator.calculateRouteDistance(points, decimals: 1);
    _dist = double.parse(distString.substring(0, distString.length - 3)) * 1000; // distString is in km; we want meters

    setState(() {});
  }
}
