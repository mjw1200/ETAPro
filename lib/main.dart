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
  @override
  Widget build(BuildContext context) {
    Widget theWidget = super.widget.permissions ? const Summary() : const NoPermission(message: 'No Permissions');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[theWidget],
        ),
      ),
    );
  }
}
