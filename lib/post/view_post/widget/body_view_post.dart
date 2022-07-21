import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/widget/floating_button_icon.dart';
import 'package:cooking_social_network/post/view_post/widget/info_food.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Scaffold bodyViewPost(BuildContext context, {Post? post, required bool check}) {
  return Scaffold(
    body: SafeArea(
      child: Stack(
        children: [
          Positioned(child: Container()),
          Positioned(
            child: Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height * 2 / 5,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: post == null ? 1 : post.images.length,
                    itemBuilder: (context, index) => post == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Image.network(post.images[index]),
                  ),
                  floatingButtonIcon(context,
                      left: 10,
                      top: 10,
                      iconData: Icons.arrow_back_ios_new_rounded,
                      iconColor: Colors.red, action: () {
                    Navigator.pop(context);
                  }),
                  floatingButtonIcon(context,
                      right: 10,
                      top: 10,
                      iconData: Icons.more_horiz_rounded,
                      iconColor: Colors.red,
                      action: () {}),
                  floatingButtonIcon(context,
                      right: 10,
                      bottom: 25,
                      iconData: check
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      iconColor: Colors.red, action: () async {
                    await PostRepository.favouriteEvent(id: post!.id);
                  })
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 2 / 5 - 20,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: InfoFood(post: post, check: check),
            ),
          )
        ],
      ),
    ),
  );
}
