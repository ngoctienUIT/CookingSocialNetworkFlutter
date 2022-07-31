import 'package:cooking_social_network/follow/view_follow_page.dart';
import 'package:cooking_social_network/main/profile/widget/item_follow_profile.dart';
import 'package:flutter/material.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;

Widget itemFollow({myuser.User? user, required BuildContext context}) {
  return IntrinsicHeight(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewFollowPage(index: 0, user: user),
              ),
            );
          },
          child: itemFollowProfile(
              user == null ? 0 : user.following.length, "following"),
        ),
        const SizedBox(width: 10),
        const VerticalDivider(
          endIndent: 10,
          indent: 10,
          thickness: 0.5,
          color: Colors.black,
        ),
        const SizedBox(width: 10),
        InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewFollowPage(index: 1, user: user),
                ),
              );
            },
            child: itemFollowProfile(
                user == null ? 0 : user.followers.length, "follower")),
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
