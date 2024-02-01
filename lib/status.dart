import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  const Status({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          margin: const EdgeInsets.all(16),
          child: Text(message, style: const TextStyle(fontSize: 20, fontFamily: 'Adlam')))
    ]);
  }
}
