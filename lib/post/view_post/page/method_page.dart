import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MethodPage extends StatelessWidget {
  const MethodPage({Key? key, this.post}) : super(key: key);
  final Post? post;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: post!.ingredients.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(90)),
                  elevation: 5,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(90))),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    post!.methods[index].title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post!.methods[index].content),
                  const SizedBox(height: 10),
                  Material(
                    elevation: 10,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          imageUrl: post!.methods[index].image,
                          placeholder: (context, url) => imageLoading(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Shimmer imageLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: Random().nextDouble() * 200 + 100,
        height: Random().nextDouble() * 150 + 100,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
