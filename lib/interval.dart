import 'package:flutter/material.dart';

class Interval extends StatelessWidget {
  Interval({super.key});

  final tec = TextEditingController(text: '15');

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          margin: const EdgeInsets.all(32.0),
          child: SizedBox(
              width: 50,
              height: 25,
              child: TextField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontFamily: 'Adlam'),
                  controller: tec)))
    ]);
  }
}

// class Interval extends StatefulWidget {
//   Interval({super.key});

//   final tec = TextEditingController(text: '999');

//   @override
//   State<StatefulWidget> createState() => IntervalState();

//   getSecondsInterval() {
//     return int.parse(tec.text);
//   }
// }

// class IntervalState extends State<Interval> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisSize: MainAxisSize.min, children: [
//       Container(
//           margin: const EdgeInsets.all(32.0),
//           child: SizedBox(
//               width: 50,
//               height: 25,
//               child: TextField(
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20, fontFamily: 'Adlam'),
//                   controller: widget.tec)))
//     ]);
//   }
// }
