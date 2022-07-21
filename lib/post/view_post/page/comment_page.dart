import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/comment.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatelessWidget {
  CommentPage({Key? key, this.post}) : super(key: key);
  final Post? post;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        writeComment(),
        Expanded(
          child: ListView.builder(
            itemCount: post!.comments.length,
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
          stream: UserRepository.getDataComment(id: post!.comments[index]),
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

            Comment comment =
                Comment.getDataFromMap(snapshot: snapshot.requireData);
            return StreamBuilder<DocumentSnapshot>(
                stream: UserRepository.getInfoUser(username: comment.userName),
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
                  return Row(
                    children: [
                      SizedBox(
                          width: 45,
                          height: 45,
                          child: ClipOval(child: Image.network(info.avatar))),
                      const SizedBox(width: 20),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(comment.content),
                          Text(comment.time.minute.toString())
                        ],
                      )),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  );
                });
          }),
    );
  }

  Row writeComment() {
    return Row(
      children: [
        const SizedBox(width: 10),
        SizedBox(
          width: 45,
          height: 45,
          child: StreamBuilder<DocumentSnapshot>(
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
                Info info =
                    Info.getDataFromSnapshot(snapshot: snapshot.requireData);
                return ClipOval(child: Image.network(info.avatar));
              }),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
              child: TextFormField(
            controller: _commentController,
            decoration: InputDecoration(
                hintText: "Bình luận",
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                suffixIcon: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.send_rounded)),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          )),
        ))
      ],
    );
  }
}