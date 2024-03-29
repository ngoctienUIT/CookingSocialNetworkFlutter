import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/profile/your_profile_page.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YourProfilePage(userName: post.owner),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            YourProfilePage(userName: post.owner),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              YourProfilePage(userName: post.owner),
                        ),
                      );
                    },
                    child: Text(post.owner)),
                Text(PostRepository.daysBetween(
                    dateTime1: post.time, dateTime2: DateTime.now()))
              ],
            )
          ],
        );
      });
}
