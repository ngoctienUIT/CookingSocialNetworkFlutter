import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/home/widget/item_loading.dart';
import 'package:cooking_social_network/main/home/widget/item_post.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowPost extends StatelessWidget {
  const FollowPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserRepository.getDataUser(
          username: FirebaseAuth.instance.currentUser!.email.toString()),
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
        myuser.User user =
            myuser.User.getDataFromSnapshot(snapshot: snapshot.requireData);
        if (user.following.isNotEmpty) {
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("post")
                  .where("owner", whereIn: user.following)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Icon(Icons.error);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                      itemCount: 10,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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

                if (docs.isNotEmpty) {
                  return GridView.builder(
                      itemCount: docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        return ItemPost(id: docs[index]);
                      });
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        "Những người bạn theo dõi chưa có bất kỳ bài viết nào!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  );
                }
              });
        } else {
          return const Center(
            child: Text(
              "Bạn chưa theo dõi ai!",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          );
        }
      },
    );
  }
}
