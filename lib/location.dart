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
    const TextStyle style = TextStyle(fontSize: 18, fontFamily: 'Adlam');
    var milesDistance = (_dist * 0.000621371).round();
    var mphSpeed = (_speed * 2.23694).round();

    var secondsRemain = (_dist / _speed).round();
    var minuteRemain = ((secondsRemain % 3600) / 60).round();
    var hourRemain = (secondsRemain / 3600).round();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Lat: ${_lat.toStringAsFixed(3)}',
          style: style,
        ),
        Text(
          'Lon: ${_lon.toStringAsFixed(3)}',
          style: style,
        ),
        Text(
          'Speed (mph): ${mphSpeed.toStringAsFixed(0)}',
          style: style,
        ),
        Text(
          'Dist remain (mi): ${milesDistance.toStringAsFixed(0)}',
          style: style,
        ),
        Text(
          'Time remain (hh:mm): ${hourRemain.round()}:${minuteRemain.round()}',
          style: style,
        )
      ],
    );
  }

  void setCurrentPosition(Timer t) async {
    // Music Villa: 45.67973305878354, -111.02897198805852
    // The Office: 45.660500254366056, -110.55933360340568
    // Touchmark: 46.57686096725291, -111.98913545917074
    // 'AIzaSyDklNhepabAAhzB_iX5jhVfIiTCU6cHfPo'

    // TODO: How stable is geolocator? Should we use a Google service instead?
    var currentPosition = await _geolocatorPlatform.getCurrentPosition();
    _lon = currentPosition.longitude;
    _lat = currentPosition.latitude;
    _speed = currentPosition.speed + 0.001; // ensure non-zero

    /// LatLng is included in google_maps_flutter
    List<LatLng> points = [
      LatLng(_lat, _lon), // where you am
      const LatLng(46.57686096725291, -111.98913545917074), // Touchmark
    ];

    DistanceCalculator distanceCalculator = DistanceCalculator();
    var distString = distanceCalculator.calculateRouteDistance(points, decimals: 3);
    _dist = double.parse(distString.substring(0, distString.length - 3)) * 1000; // distString is in km; we want meters

    setState(() {});
  }
}
