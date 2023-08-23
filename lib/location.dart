import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<StatefulWidget> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  Position _lastPos = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  @override
  void initState() {
    // _lastPos = await geolocatorPlatform.getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      OutlinedButton(onPressed: setCurrentPosition, child: const Text('Push to Locate')),
      const Padding(padding: EdgeInsets.all(8.0)),
      Text('Lat: ${_lastPos.latitude} Lon: ${_lastPos.longitude}')
    ]);
  }

  Future<void> setCurrentPosition() async {
    setState(() {});

    _lastPos = await _geolocatorPlatform.getCurrentPosition();
  }
}
