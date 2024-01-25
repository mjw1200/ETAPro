// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:etapro_flutter/summary.dart';
import 'package:etapro_flutter/no_permission.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io' show Platform;

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
        title: 'ETAPro',
        permissions: permissions,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.permissions});

  final String title;
  final bool permissions;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  bool getPermissions() {
    return permissions;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool _startEnabled = false;
  bool _isStarted = false;

  @override
  Widget build(BuildContext context) {
    String status = _isStarted ? 'Running' : 'Stopped';
    const TextStyle style = TextStyle(fontSize: 20, fontFamily: 'Adlam');
    Widget theWidget = super.widget.permissions
        ? Text(
            status,
            style: style,
          )
        : const NoPermission(message: 'No Permissions');

    const String appTitle = 'ETAPro';
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          body: Center(
              child: Column(children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  margin: EdgeInsets.all(32.0),
                  child: IconButton(
                      iconSize: 64.0,
                      onPressed: _startEnabled ? _handleStartPress : null,
                      icon: Icon(
                        Icons.start,
                        color: _startEnabled ? Colors.green : Colors.grey,
                      ))),
              Container(
                  margin: EdgeInsets.all(32.0),
                  child: IconButton(
                      iconSize: 64.0,
                      onPressed: _startEnabled ? null : _handleStopPress,
                      icon: Icon(Icons.stop, color: _startEnabled ? Colors.grey : Colors.red)))
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  margin: EdgeInsets.all(32.0),
                  child: SizedBox(
                      width: 50,
                      height: 25,
                      child: TextField(
                          textAlign: TextAlign.center, style: style, controller: TextEditingController(text: '999'))))
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: [Container(margin: EdgeInsets.all(32.0), child: theWidget)])
          ], mainAxisSize: MainAxisSize.min)),
        ));
  }

  void _handleStopPress() {
    _startEnabled = true;
    _isStarted = false;
    setState(() {});
  }

  void _handleStartPress() {
    _startEnabled = false;
    _isStarted = true;
    setState(() {});
  }
}
