import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

IntrinsicHeight reactFood({Post? post, required Function action}) {
  return IntrinsicHeight(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                const Icon(
                  Icons.favorite_outline_rounded,
                  color: Colors.red,
                ),
                Text(post!.favourites.length.toString())
              ],
            ),
          ),
        ),
        const VerticalDivider(
          endIndent: 5,
          indent: 5,
          thickness: 0.5,
          color: Colors.black,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              action();
            },
            child: Column(
              children: [
                const Icon(
                  FontAwesomeIcons.comment,
                  color: Colors.green,
                ),
                Text(post.comments.length.toString())
              ],
            ),
          ),
        ),
        const VerticalDivider(
          endIndent: 5,
          indent: 5,
          thickness: 0.5,
          color: Colors.black,
        ),
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                const Icon(
                  FontAwesomeIcons.share,
                  color: Colors.red,
                ),
                Text(post.share.toString())
              ],
            ),
          ),
        )
      ],
    ),
  );
}
