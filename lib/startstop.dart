import 'package:flutter/material.dart';

class StartStop extends StatelessWidget {
  const StartStop({super.key, required this.toggleStateFunction, required this.running});

  final void Function() toggleStateFunction;
  final bool running;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      _containerizedIconButton(Colors.grey, Colors.green, Icons.start),
      _containerizedIconButton(Colors.red, Colors.grey, Icons.stop)
    ]);
  }

  //------------------------------------------------------------------------------------------------------------------
  Container _containerizedIconButton(MaterialColor runningColor, MaterialColor stoppedColor, IconData icon) {
    return Container(
        margin: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
        child: IconButton(
            iconSize: 64.0,
            // This onPressed value is a little bit ugly, although it seems to work. I've tried to clean it up, but
            // ran into a problem where "void Function() foo" is not equal to "void Function()? foo"... because we
            // need this value to be null to disable the IconButton.
            onPressed:
                ((icon == Icons.start && !running) || (icon == Icons.stop && running)) ? toggleStateFunction : null,
            icon: Icon(icon, color: running ? runningColor : stoppedColor)));
  }
}
