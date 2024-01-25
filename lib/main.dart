import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;
import 'package:etapro_flutter/startstop.dart';
import 'package:etapro_flutter/interval.dart' as etapro_interval;
import 'package:etapro_flutter/status.dart';

void main() {
  ensurePermissions().then((value) => {runApp(MyApp(permissions: value))});
}

Future<bool> ensurePermissions() async {
  if (Platform.isWindows) {
    return true;
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    } else if (permission == LocationPermission.denied) {
      var permission2 = await Geolocator.requestPermission();
      if (permission2 == LocationPermission.always || permission2 == LocationPermission.whileInUse) {
        return true;
      }
    }
  }

  return false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.permissions});

  final bool permissions;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETAPro_Flutter',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: MyHomePage(
        permissions: permissions,
        title: 'ETAPro',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.permissions, required this.title});

  final bool permissions;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  bool getPermissions() {
    return permissions;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool _running = false;

  @override
  Widget build(BuildContext context) {
    var startStop = StartStop(toggleStateFunction: _toggleState, running: _running);
    var interval = etapro_interval.Interval();
    String statusMessage = _running ? 'Running' : 'Stopped';
    var status = Status(message: statusMessage);

    const String appTitle = 'ETAPro';
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [startStop, interval, status])),
        ));
  }

  void _toggleState() {
    setState(() {
      _running = !_running;
    });
  }
}
