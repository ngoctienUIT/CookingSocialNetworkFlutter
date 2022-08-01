import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/generated/l10n.dart';
import 'package:cooking_social_network/model/comment.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/post/view_post/widget/loading_comment.dart';
import 'package:cooking_social_network/profile/your_profile_page.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

Widget commentItem(
    {required String idComment,
    required String idPost,
    required String username,
    required BuildContext context}) {
  return StreamBuilder<DocumentSnapshot>(
      stream: PostRepository.getDataComment(id: idComment),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Không có gì ở đây"));
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
              return FocusedMenuHolder(
                menuWidth: MediaQuery.of(context).size.width * 0.50,
                blurSize: 5.0,
                menuItemExtent: 45,
                menuBoxDecoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                duration: const Duration(milliseconds: 100),
                animateMenuItems: true,
                blurBackgroundColor: Colors.black54,
                openWithTap: false,
                menuOffset: 10.0,
                bottomOffsetHeight: 80.0,
                menuItems: [
                  FocusedMenuItem(
                      title: Text(
                          check ? S.current.unfavorite : S.current.favorite),
                      trailingIcon: Icon(
                        check
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        PostRepository.favouristComment(id: idComment);
                      }),
                  FocusedMenuItem(
                      title: Text(S.current.copy),
                      trailingIcon: const Icon(
                        Icons.copy_rounded,
                        color: Colors.green,
                      ),
                      onPressed: () async {
                        await FlutterClipboard.copy(comment.content);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Sao chép thành công",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }),
                  if (comment.userName ==
                          FirebaseAuth.instance.currentUser!.email.toString() ||
                      username ==
                          FirebaseAuth.instance.currentUser!.email.toString())
                    FocusedMenuItem(
                        title: Text(
                          S.current.delete,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                        trailingIcon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          PostRepository.removeComment(
                              idComment: idComment, idPost: idPost);
                        }),
                ],
                onPressed: () {},
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            toProfilePage(
                                username: comment.userName, context: context);
                          },
                          child: SizedBox(
                              width: 45,
                              height: 45,
                              child:
                                  ClipOval(child: Image.network(info.avatar))),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                toProfilePage(
                                    username: comment.userName,
                                    context: context);
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
                                PostRepository.favouristComment(id: idComment);
                              },
                            ),
                            Text(comment.favourites.length.toString())
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      });
}

void toProfilePage({required String username, required BuildContext context}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => YourProfilePage(userName: username),
    ),
  );
}
