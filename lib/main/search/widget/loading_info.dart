import 'dart:math';
import 'package:flutter/material.dart';

Widget loadingInfo() {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(90),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Random().nextDouble() * 50 + 50,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: Random().nextDouble() * 150 + 50,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.favorite),
        Container(
          width: Random().nextDouble() * 10 + 15,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    ),
  );
}
