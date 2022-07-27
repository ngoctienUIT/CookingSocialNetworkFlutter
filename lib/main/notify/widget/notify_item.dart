import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/notify/widget/loading_notify.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/notify.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/view_post_page.dart';
import 'package:cooking_social_network/profile/your_profile_page.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:shimmer/shimmer.dart';

Widget notifyItem({required String id, String? type}) {
  return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("notify").doc(id).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingNotify();
        }

        Notify notify =
            Notify.getDataFromSnapshot(snapshot: snapshot.requireData);
        if (notify.type == type || type == null) {
          return bodyNotify(notify);
        } else {
          return const SizedBox.shrink();
        }
      });
}

Widget bodyNotify(Notify notify) {
  return StreamBuilder<DocumentSnapshot>(
      stream: UserRepository.getInfoUser(username: notify.user),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingNotify();
        }

        Info info = Info.getDataFromSnapshot(snapshot: snapshot.requireData);
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => notify.type == "follow"
                    ? YourProfilePage(userName: notify.user)
                    : ViewPostPage(id: notify.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: info.avatar,
                    width: 50,
                    height: 50,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 50,
                        width: Random().nextDouble() * 50 + 50,
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notify.type == "follow"
                            ? "Đã theo dõi bạn"
                            : (notify.type == "comment"
                                ? "Đã bình luận: ${notify.content}"
                                : "Đã thích bài viết"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        PostRepository.daysBetween(
                          dateTime1: notify.time,
                          dateTime2: DateTime.now(),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                notify.type == "follow"
                    ? refollowButton(notify)
                    : imagePost(notify)
              ],
            ),
          ),
        );
      });
}

Widget imagePost(Notify notify) {
  return StreamBuilder<DocumentSnapshot>(
      stream: PostRepository.getDataPost(id: notify.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: Random().nextDouble() * 50 + 50,
              height: 50,
              color: Colors.grey,
            ),
          );
        }

        Post post = Post.getDataFromSnapshot(snapshot: snapshot.requireData);
        return CachedNetworkImage(
          imageUrl: post.images[0],
          width: 50,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 50,
              width: Random().nextDouble() * 50 + 50,
              color: Colors.grey,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      });
}

Widget refollowButton(Notify notify) {
  return StreamBuilder<DocumentSnapshot>(
      stream: UserRepository.getDataUser(
          username: FirebaseAuth.instance.currentUser!.email.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 120,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }
        myuser.User user =
            myuser.User.getDataFromSnapshot(snapshot: snapshot.requireData);
        return SizedBox(
          width: 120,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              UserRepository.followEvent(username: notify.user);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: Text(user.following.contains(notify.user)
                ? "Hủy Follow"
                : "Follow lại"),
          ),
        );
      });
}
