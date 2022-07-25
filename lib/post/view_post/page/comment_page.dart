import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/comment.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/profile/your_profile_page.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key, this.post}) : super(key: key);
  final Post? post;

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String comment = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        writeComment(),
        Expanded(
          child: ListView.builder(
            itemCount: widget.post!.comments.length,
            itemBuilder: (context, index) => commentItem(index),
          ),
        )
      ],
    );
  }

  Widget commentItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: StreamBuilder<DocumentSnapshot>(
          stream:
              PostRepository.getDataComment(id: widget.post!.comments[index]),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Không có gì ở đây"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingComment();
            }

            Comment comment =
                Comment.getDataFromMap(snapshot: snapshot.requireData);
            bool check = comment.favourites
                .contains(FirebaseAuth.instance.currentUser!.email.toString());
            return StreamBuilder<DocumentSnapshot>(
                stream: UserRepository.getInfoUser(username: comment.userName),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Không có gì ở đây"),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingComment();
                  }
                  Info info =
                      Info.getDataFromSnapshot(snapshot: snapshot.requireData);
                  return Row(
                    children: [
                      InkWell(
                        onTap: () {
                          toProfilePage(username: widget.post!.owner);
                        },
                        child: SizedBox(
                            width: 45,
                            height: 45,
                            child: ClipOval(child: Image.network(info.avatar))),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              toProfilePage(username: widget.post!.owner);
                            },
                            child: Text(
                              info.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Text(comment.content),
                          Text(PostRepository.daysBetween(
                              dateTime1: comment.time,
                              dateTime2: DateTime.now()))
                        ],
                      )),
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              check
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              PostRepository.favouristComment(
                                  id: widget.post!.comments[index]);
                            },
                          ),
                          Text(comment.favourites.length.toString())
                        ],
                      ),
                    ],
                  );
                });
          }),
    );
  }

  Widget loadingComment() {
    return Shimmer.fromColors(
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
                const SizedBox(height: 5),
                Container(
                  width: Random().nextDouble() * 10 + 30,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.favorite),
              Container(
                width: 20,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget writeComment() {
    TextEditingController controller = TextEditingController();
    return Row(
      children: [
        SizedBox(
          width: 45,
          height: 45,
          child: StreamBuilder<DocumentSnapshot>(
              stream: UserRepository.getInfoUser(username: widget.post!.owner),
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
                Info info =
                    Info.getDataFromSnapshot(snapshot: snapshot.requireData);
                return ClipOval(child: Image.network(info.avatar));
              }),
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  child: TextFormField(
                    controller: comment.isEmpty ? controller : null,
                    onChanged: (text) {
                      setState(() {
                        comment = text;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Bình luận",
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        suffixIcon: comment.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  PostRepository.addComment(
                                      id: widget.post!.id, content: comment);
                                  setState(() {
                                    comment = "";
                                    controller.text = "";
                                  });
                                },
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.blue,
                                ),
                              ),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  void toProfilePage({required String username}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YourProfilePage(userName: widget.post!.owner),
      ),
    );
  }
}
