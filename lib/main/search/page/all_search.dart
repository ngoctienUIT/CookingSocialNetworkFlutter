import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';

class AllSearch extends StatelessWidget {
  const AllSearch({Key? key, required this.query}) : super(key: key);
  final String query;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("info").get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Không có gì ở đây"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Info> listUser = snapshot.data!.docs
              .map(
                (doc) => Info.getDataFromSnapshot(snapshot: doc),
              )
              .toList()
              .where((user) =>
                  user.username.toLowerCase().contains(query.toLowerCase()) ||
                  user.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection("post").get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Icon(Icons.error);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Post> listPost = snapshot.data!.docs
                    .map(
                      (doc) => Post.getDataFromSnapshot(snapshot: doc),
                    )
                    .toList()
                    .where((post) =>
                        post.nameFood
                            .toLowerCase()
                            .contains(query.toLowerCase()) ||
                        post.owner.toLowerCase().contains(query.toLowerCase()))
                    .toList();

                return Text("data");
              });
        });
  }
}
