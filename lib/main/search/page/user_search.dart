import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/profile/your_profile_page.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserSearch extends StatelessWidget {
  const UserSearch({Key? key, required this.query}) : super(key: key);
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
            return loadingUser();
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

          return ListView.builder(
              itemCount: listUser.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            YourProfilePage(userName: listUser[index].username),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: listUser[index].avatar,
                              width: 50,
                              height: 50,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listUser[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(listUser[index].username)
                            ],
                          ),
                          const Spacer(),
                          FirebaseAuth.instance.currentUser!.email.toString() ==
                                  listUser[index].username
                              ? const SizedBox.shrink()
                              : StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("user")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email
                                          .toString())
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Icon(Icons.error);
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 120,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      );
                                    }

                                    myuser.User user =
                                        myuser.User.getDataFromSnapshot(
                                            snapshot: snapshot.requireData);

                                    return SizedBox(
                                      width: 120,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          UserRepository.followEvent(
                                              username:
                                                  listUser[index].username);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                        ),
                                        child: Text(user.following.contains(
                                                listUser[index].username)
                                            ? "Hủy Follow"
                                            : "Follow"),
                                      ),
                                    );
                                  })
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  ListView loadingUser() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: [
                  ClipOval(
                    child: Container(width: 45, height: 45, color: Colors.grey),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Random().nextDouble() * 100 + 50,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: Random().nextDouble() * 150 + 50,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
