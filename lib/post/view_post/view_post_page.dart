import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/widget/body_view_post.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:flutter/material.dart';

class ViewPostPage extends StatelessWidget {
  const ViewPostPage({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: UserRepository.getDataPost(id: id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("data");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return bodyViewPost(context);
          }
          var post = Post.getDataFromSnapshot(snapshot: snapshot.requireData);

          return bodyViewPost(context, post: post);
        });
  }
}
