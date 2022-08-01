import 'package:cached_network_image/cached_network_image.dart';
import 'package:cooking_social_network/main/search/widget/info_post.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget miniPost(Post post) {
  return Container(
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
              child: CachedNetworkImage(
                imageUrl: post.images[0],
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.grey),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          post.nameFood,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        infoPost(post)
      ],
    ),
  );
}
