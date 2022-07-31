import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/widget/comment_item.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:flutter/material.dart';

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
            itemBuilder: (context, index) => commentItem(
                idComment: widget.post!.comments[index],
                idPost: widget.post!.id,
                username: widget.post!.owner,
                context: context),
          ),
        )
      ],
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
}
