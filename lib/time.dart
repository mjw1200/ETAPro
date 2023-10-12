class Time {
  double secondsSinceEpoch() {
    return DateTime.now().millisecondsSinceEpoch / Duration.millisecondsPerSecond;
  }
}
