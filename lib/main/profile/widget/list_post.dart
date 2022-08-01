import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:flutter/material.dart';
import 'mini_post.dart';

Widget listPost({required myuser.User user, required int index}) {
  List<dynamic> list;
  switch (index) {
    case 0:
      list = user.post;
      break;
    case 1:
      list = user.favourites;
      break;
    default:
      list = user.post;
      break;
  }

  return list.isEmpty
      ? const Center(child: Text("Không có gì ở đây"))
      : SizedBox(
          height:
              (list.length % 3 > 0 ? list.length / 3 + 1 : list.length / 3) *
                  230,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 2 / 3,
            ),
            itemBuilder: (context, index) => miniPost(id: list[index]),
          ),
        );
}
