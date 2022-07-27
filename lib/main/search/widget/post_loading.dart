import 'dart:math';
import 'package:cooking_social_network/main/search/widget/loading_info.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget postLoading() {
  return GridView.builder(
    itemCount: 10,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      childAspectRatio: 2 / 3,
    ),
    itemBuilder: (context, index) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(color: Colors.grey),
                ),
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
            loadingInfo()
          ],
        ),
      ),
    ),
  );
}
