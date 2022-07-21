import 'package:flutter/material.dart';

Positioned floatingButtonIcon(BuildContext context,
    {double? left,
    double? right,
    double? top,
    double? bottom,
    required IconData iconData,
    required Color iconColor,
    required Function action}) {
  return Positioned(
    left: left,
    top: top,
    bottom: bottom,
    right: right,
    child: InkWell(
      onTap: () {
        action();
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Icon(
          iconData,
          color: iconColor,
        ),
      ),
    ),
  );
}
