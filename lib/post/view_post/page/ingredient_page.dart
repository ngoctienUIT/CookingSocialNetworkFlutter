import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';

class IngredientPage extends StatelessWidget {
  const IngredientPage({Key? key, this.post}) : super(key: key);
  final Post? post;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: post!.ingredients.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: [
            Text(post!.ingredients[index].name),
            const Spacer(),
            Text(post!.ingredients[index].amount.toString()),
            const SizedBox(width: 10),
            Text(post!.ingredients[index].unit)
          ],
        ),
      ),
    );
  }
}
