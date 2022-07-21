import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/widget/info_cooking_food.dart';
import 'package:cooking_social_network/post/view_post/widget/info_owner.dart';
import 'package:cooking_social_network/post/view_post/widget/react_food.dart';
import 'package:flutter/material.dart';

class InfoFoodPage extends StatelessWidget {
  const InfoFoodPage({Key? key, this.post, required this.action})
      : super(key: key);
  final Post? post;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            infoOwner(post: post),
            const SizedBox(height: 20),
            infoCookingFood(post: post),
            const SizedBox(height: 10),
            Text(post!.description),
            const SizedBox(height: 20),
            reactFood(
                post: post,
                action: () {
                  action();
                }),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
