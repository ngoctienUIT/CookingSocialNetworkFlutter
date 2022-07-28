import 'package:flutter/material.dart';

Widget itemSetting(
    {required String text, required Function action, required IconData icon}) {
  return InkWell(
    onTap: () {
      action();
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Icon(
            icon,
            size: 35,
          ),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(fontSize: 18),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded)
        ],
      ),
    ),
  );
}
