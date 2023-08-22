import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class Location extends StatelessWidget {
  final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  final Position lastPosition = Position(
      longitude: 2.9,
      latitude: 3.4,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  Location({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Lat: ${lastPosition.latitude} Lon: ${lastPosition.longitude}',
      style:
          const TextStyle(fontSize: 24, color: Color.fromARGB(255, 74, 11, 11)),
    );
  }

  // Future<void> setCurrentPosition() async =>
  //     {
  //       Position pos = await geolocatorPlatform.getCurrentPosition();
  //       lastPosition.lat
  //     };
}
