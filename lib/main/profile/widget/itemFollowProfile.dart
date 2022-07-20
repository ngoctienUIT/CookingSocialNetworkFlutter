import 'package:flutter/material.dart';

Column itemFollowProfile(int number, String text) {
  return Column(
    children: [
      Text(
        number.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 5),
      Text(
        text,
        style: const TextStyle(fontSize: 15),
      )
    ],
  );
}
