import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/home/widget/item_loading.dart';
import 'package:cooking_social_network/main/home/widget/item_post.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewPost extends StatelessWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("post")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
                itemCount: 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 2 / 3,
                ),
                itemBuilder: (context, index) {
                  return itemLoading();
                });
          }

          List<String> docs = [];
          for (var element in snapshot.requireData.docs) {
            docs.add(element.id);
          }

          return GridView.builder(
              itemCount: docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                return ItemPost(id: docs[index]);
              });
        });
  }
}
