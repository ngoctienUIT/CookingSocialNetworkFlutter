import 'package:flutter/material.dart';

Widget reactWidget(
    {required IconData icon,
    required Color color,
    double size = 20,
    required String text}) {
  return Row(
    children: [
      Text(text, style: const TextStyle(fontSize: 13)),
      const SizedBox(width: 3),
      Icon(
        icon,
        size: size,
        color: color,
      )
    ],
  );
}
