import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/search/widget/loading_info.dart';
import 'package:cooking_social_network/main/search/widget/post_loading.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/view_post_page.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostSearch extends StatelessWidget {
  const PostSearch({Key? key, required this.query}) : super(key: key);
  final String query;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("post").get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return postLoading();
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
                child: miniPost(listPost[index]),
              );
            });
      },
    );
  }

  Container miniPost(Post post) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: CachedNetworkImage(
                  imageUrl: post.images[0],
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.grey),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            post.nameFood,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          infoPost(post)
        ],
      ),
    );
  }

  Widget infoPost(Post post) {
    return FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection("info").doc(post.owner).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: loadingInfo());
          }

          Info info = Info.getDataFromSnapshot(snapshot: snapshot.requireData);

          return Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: info.avatar,
                    width: 30,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child:
                          Container(width: 30, height: 30, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(info.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis),
                      Text(info.username, overflow: TextOverflow.ellipsis)
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
                        post.favourites.length.toString(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
