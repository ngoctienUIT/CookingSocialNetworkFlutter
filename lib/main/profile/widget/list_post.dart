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
      ? const Text("Không có gì ở đây")
      : SizedBox(
          height:
              (list.length % 3 > 0 ? list.length / 3 + 1 : list.length / 3) *
                  230,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 2 / 3,
            ),
            itemBuilder: (context, index) => miniPost(id: list[index]),
          ),
        );

  /*return GridView.count(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    crossAxisCount: 3,
    crossAxisSpacing: 2,
    mainAxisSpacing: 2,
    childAspectRatio: 2 / 3,
    children: List.generate(
      list.isEmpty ? 0 : list.length,
      (index) {
        return Container(
          decoration: const BoxDecoration(color: Colors.red),
          child: Stack(children: [
            Center(child: Image.asset("assets/images/cooking.png")),
            Positioned(
              right: 5,
              bottom: 5,
              child: Row(
                children: const [
                  Icon(Icons.favorite_outline_rounded,
                      color: Colors.white, size: 18),
                  Text("123", style: TextStyle(color: Colors.white)),
                ],
              ),
            )
          ]),
        );
      },
    ),
  );*/
}
