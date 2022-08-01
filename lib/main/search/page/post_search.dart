import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/search/widget/mini_post.dart';
import 'package:cooking_social_network/main/search/widget/post_loading.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/view_post_page.dart';
import 'package:flutter/material.dart';

class PostSearch extends StatelessWidget {
  const PostSearch({Key? key, required this.query}) : super(key: key);
  final String query;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("post").get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return postLoading();
        }

        List<Post> listPost = snapshot.data!.docs
            .map(
              (doc) => Post.getDataFromSnapshot(snapshot: doc),
            )
            .toList()
            .where((post) =>
                post.nameFood.toLowerCase().contains(query.toLowerCase()) ||
                post.owner.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return GridView.builder(
            itemCount: listPost.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 2 / 3,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewPostPage(id: listPost[index].id),
                    ),
                  );
                },
                child: miniPost(listPost[index]),
              );
            });
      },
    );
  }
}
