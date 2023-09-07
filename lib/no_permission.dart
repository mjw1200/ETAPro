import 'package:flutter/material.dart';

class NoPermission extends StatelessWidget {
  const NoPermission({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 18, fontFamily: 'Adlam');
    return Text(
      message,
      style: style,
    );
  }
}
