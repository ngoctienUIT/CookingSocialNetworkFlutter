import 'package:cooking_social_network/main/profile/widget/itemFollowProfile.dart';
import 'package:flutter/material.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;

Row itemFollow({myuser.User? user}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      itemFollowProfile(user == null ? 0 : user.following.length, "following"),
      const SizedBox(width: 20),
      itemFollowProfile(user == null ? 0 : user.followers.length, "follower"),
      const SizedBox(width: 20),
      itemFollowProfile(user == null ? 0 : user.post.length, "post")
    ],
  );
}
