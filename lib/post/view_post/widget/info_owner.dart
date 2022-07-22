import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/profile/your_profile_page.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:flutter/material.dart';

Widget infoOwner({Post? post}) {
  return StreamBuilder<DocumentSnapshot>(
      stream: UserRepository.getInfoUser(username: post!.owner),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Không có gì ở đây"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        Info info = Info.getDataFromSnapshot(snapshot: snapshot.requireData);
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                bool check = await UserRepository.checkFollow(
                    username: "ab123@gmail.com");
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YourProfilePage(
                      userName: post.owner,
                      check: check,
                    ),
                  ),
                );
              },
              child: ClipOval(
                child: Image.network(
                  info.avatar,
                  width: 55,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    bool check = await UserRepository.checkFollow(
                        username: "ab123@gmail.com");
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YourProfilePage(
                          userName: post.owner,
                          check: check,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    info.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                    onTap: () async {
                      bool check = await UserRepository.checkFollow(
                          username: "ab123@gmail.com");
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YourProfilePage(
                            userName: post.owner,
                            check: check,
                          ),
                        ),
                      );
                    },
                    child: Text(post.owner)),
                Text("${post.time.minute} phút")
              ],
            )
          ],
        );
      });
}
