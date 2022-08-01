import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/search/widget/loading_info.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget infoPost(Post post) {
  return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection("info").doc(post.owner).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: loadingInfo());
        }

        Info info = Info.getDataFromSnapshot(snapshot: snapshot.requireData);

        return Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: info.avatar,
                  width: 30,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(width: 30, height: 30, color: Colors.grey),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(info.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    Text(info.username, overflow: TextOverflow.ellipsis)
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      post.favourites.length.toString(),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}
