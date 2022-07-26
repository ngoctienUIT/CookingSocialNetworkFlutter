import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/view_post_page.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget miniPost({required String id}) {
  return StreamBuilder<DocumentSnapshot>(
      stream: PostRepository.getDataPost(id: id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.grey),
          );
        }

        var post = Post.getDataFromSnapshot(snapshot: snapshot.requireData);
        return InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewPostPage(id: id)));
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.red,
                  ],
                ),
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Stack(children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: post.images[0],
                  placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.grey)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Positioned(
                right: 5,
                bottom: 5,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_outline_rounded,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 5),
                      Text(post.favourites.length.toString(),
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        );
      });
}
