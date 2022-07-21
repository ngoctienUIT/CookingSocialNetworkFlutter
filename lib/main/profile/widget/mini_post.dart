import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/view_post_page.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:flutter/material.dart';

Widget miniPost({required String id}) {
  return StreamBuilder<DocumentSnapshot>(
      stream: PostRepository.getDataPost(id: id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("data");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("data");
        }

        var post = Post.getDataFromSnapshot(snapshot: snapshot.requireData);
        return InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewPostPage(id: id)));
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Stack(children: [
              Center(child: Image.network(post.images[0].toString())),
              Positioned(
                right: 5,
                bottom: 5,
                child: Row(
                  children: [
                    const Icon(Icons.favorite_outline_rounded,
                        color: Colors.white, size: 18),
                    Text(post.favourites.length.toString(),
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ]),
          ),
        );
      });
}
