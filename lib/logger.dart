import 'dart:core';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:etapro_flutter/time.dart';

class Logger {
  // ----------------------------------------------------------------------------------------------
  // Logger is a singleton
  static final Logger _singleton = Logger._internal();
  Directory? _directory;
  factory Logger({bool newLogFile = false}) {
    if (newLogFile) {
      _singleton._setLogFileName();
    }

    return _singleton;
  }
  Logger._internal() {
    getApplicationDocumentsDirectory().then((value) => {_directory = value, _setLogFileName()});
  }

  // ----------------------------------------------------------------------------------------------
  // Just class things
  String? _logFileName;

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
