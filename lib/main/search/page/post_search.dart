import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/view_post_page.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostSearch extends StatelessWidget {
  const PostSearch({Key? key, required this.query}) : super(key: key);
  final String query;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("post").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Không có gì ở đây"));
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
                post.nameFood.toLowerCase().contains(query.toLowerCase()) ||
                post.owner.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return GridView.builder(
            itemCount: listPost.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
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
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.network(
                            listPost[index].images[0],
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      listPost[index].nameFood,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("info")
                            .doc(listPost[index].owner)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text("Không có gì ở đây"));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          Info info = Info.getDataFromSnapshot(
                              snapshot: snapshot.requireData);
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    info.avatar,
                                    width: 30,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(info.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis),
                                      Text(info.username,
                                          overflow: TextOverflow.ellipsis)
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite_border_rounded,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        listPost[index]
                                            .favourites
                                            .length
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        })
                  ],
                ),
              );
            });
      },
    );
  }
}
