import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/search/widget/item_user.dart';
import 'package:cooking_social_network/main/search/widget/mini_post.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/view_post_page.dart';
import 'package:flutter/material.dart';

class AllSearch extends StatelessWidget {
  const AllSearch(
      {Key? key,
      required this.query,
      required this.toPostPage,
      required this.toUserPage})
      : super(key: key);
  final String query;
  final Function toUserPage;
  final Function toPostPage;

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

                int size = listUser.length > 5 ? 5 : listUser.length;

                if (listUser.isEmpty && listPost.isEmpty) {
                  return const Center(
                      child: Text("Không tìm thấy kết quả"));
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (size > 0)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Text(
                                "Người dùng",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    toUserPage();
                                  },
                                  child: const Text("Xem tất cả"))
                            ],
                          ),
                        ),
                      if (size > 0) const SizedBox(height: 10),
                      for (int i = 0; i < size; i++)
                        itemUser(context, listUser[i]),
                      if (listPost.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          child: Row(
                            children: [
                              const Text(
                                "Bài viết",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    toPostPage();
                                  },
                                  child: const Text("Xem tất cả"))
                            ],
                          ),
                        ),
                      if (listPost.isNotEmpty)
                        GridView.builder(
                            itemCount: listPost.length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 2 / 3,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewPostPage(id: listPost[index].id),
                                    ),
                                  );
                                },
                                child: miniPost(listPost[index]),
                              );
                            })
                    ],
                  ),
                );
              });
        });
  }
}
