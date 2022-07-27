import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget loadingNotify() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 50,
              height: 50,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Random().nextDouble() * 100 + 50,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                const SizedBox(height: 5),
                Container(
                  width: Random().nextDouble() * 150 + 100,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                const SizedBox(height: 5),
                Container(
                  width: Random().nextDouble() * 50 + 30,
                  height: 10,
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: Random().nextDouble() * 50 + 50,
            height: 50,
            color: Colors.grey,
          )
        ],
      ),
    ),
  );
}
