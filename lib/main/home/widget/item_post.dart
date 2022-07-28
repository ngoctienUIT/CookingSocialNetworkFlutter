import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/home/widget/item_loading.dart';
import 'package:cooking_social_network/main/home/widget/react_widget.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/view_post_page.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemPost extends StatelessWidget {
  const ItemPost({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection("post").doc(id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return itemLoading();
          }

          Post post = Post.getDataFromSnapshot(snapshot: snapshot.requireData);
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPostPage(id: id),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10)),
                            child: Image.network(
                              post.images[0],
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              post.favourites.contains(FirebaseAuth
                                      .instance.currentUser!.email
                                      .toString())
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              PostRepository.favouriteEvent(id: id);
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post.nameFood,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color.fromRGBO(64, 70, 78, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text(
                          "${post.cookingTime} phút",
                          style: const TextStyle(
                            color: Color.fromRGBO(160, 164, 167, 1),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${post.level}/5",
                          style: const TextStyle(
                            color: Color.fromRGBO(160, 164, 167, 1),
                          ),
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.yellowAccent,
                          size: 18,
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        reactWidget(
                            icon: Icons.favorite_border_rounded,
                            color: Colors.red,
                            size: 24,
                            text: post.favourites.length.toString()),
                        const Spacer(),
                        reactWidget(
                            icon: FontAwesomeIcons.comment,
                            color: Colors.green,
                            text: post.comments.length.toString()),
                        const Spacer(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
