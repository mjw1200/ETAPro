class Time {
  int secondsSinceEpoch() {
    double t = DateTime.now().millisecondsSinceEpoch / Duration.millisecondsPerSecond;
    return t.round();
  }
}
