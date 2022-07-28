import 'package:flutter/material.dart';

Widget showError(bool check, String text) {
  if (check) {
    return const SizedBox.shrink();
  } else {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
