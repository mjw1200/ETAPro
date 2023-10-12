import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:etapro_flutter/time.dart';

class Logger {
  // ----------------------------------------------------------------------------------------------
  // Logger is a singleton
  static final Logger _singleton = Logger._internal();
  factory Logger() {
    return _singleton;
  }
  Logger._internal() {
    getApplicationDocumentsDirectory().then((value) => {_setLogFileName(value)});
  }

  // ----------------------------------------------------------------------------------------------
  // Just class things
  late String _logFileName;

  void log(String message) {
    File(_logFileName).writeAsStringSync('$message\n', mode: FileMode.append);
  }

  void _setLogFileName(Directory dir) {
    var tZero = Time().secondsSinceEpoch();
    _logFileName = '${dir.path}/etapro_debug_$tZero.txt';
  }
}
