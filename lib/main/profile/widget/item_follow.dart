import 'package:cooking_social_network/main/profile/widget/item_follow_profile.dart';
import 'package:flutter/material.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;

Widget itemFollow({myuser.User? user}) {
  return IntrinsicHeight(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        itemFollowProfile(
            user == null ? 0 : user.following.length, "following"),
        const SizedBox(width: 10),
        const VerticalDivider(
          endIndent: 10,
          indent: 10,
          thickness: 0.5,
          color: Colors.black,
        ),
        const SizedBox(width: 10),
        itemFollowProfile(user == null ? 0 : user.followers.length, "follower"),
        const SizedBox(width: 10),
        const VerticalDivider(
          endIndent: 10,
          indent: 10,
          thickness: 0.5,
          color: Colors.black,
        ),
        const SizedBox(width: 10),
        itemFollowProfile(user == null ? 0 : user.post.length, "post")
      ],
    ),
  );
}
