import 'dart:core';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:etapro_flutter/time.dart';

// --------------------------------------------------------------------------------------------------------------------
// Logger is a singleton, which is why this class looks odd. The program should be able to call the constructor
// anywhere it's needed, and get the same instance. That way there's only one log file at a time.

class Logger {
  static final Logger _singleton = Logger._internal();
  Directory? _directory;
  String? _logFileName;

  factory Logger({bool newLogFile = false}) {
    if (newLogFile) {
      // Create a new log file with a name based on the current timestamp.
      _singleton._setLogFileName();
    }

    return _singleton;
  }

  Logger._internal() {
    getApplicationDocumentsDirectory().then((value) => {_directory = value, _setLogFileName()});
  }

  void log(String message) {
    if (_logFileName != null) {
      File(_logFileName!).writeAsStringSync('${Time().secondsSinceEpoch()} $message\n', mode: FileMode.append);
    }
  }

  void _setLogFileName() {
    if (_directory != null) {
      var tZero = Time().secondsSinceEpoch();
      _logFileName = '${_directory!.path}/etapro_debug_$tZero.txt';
    }
  }
}
