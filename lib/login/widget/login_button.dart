import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget loginButton(
    {required IconData icon,
    required String text,
    required Color color,
    required Function action}) {
  return Expanded(
    child: ElevatedButton.icon(
      icon: FaIcon(
        icon,
        size: 25,
      ),
      label: Text(text),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 10),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      onPressed: () async {
        action();
      },
    ),
  );
}
