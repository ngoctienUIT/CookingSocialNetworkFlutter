import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';

IntrinsicHeight infoCookingFood({Post? post}) {
  return IntrinsicHeight(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              const Text("Thời gian nấu"),
              Text(
                "${post!.cookingTime} phút",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
        ),
        const VerticalDivider(
          endIndent: 5,
          indent: 5,
          thickness: 0.5,
          color: Colors.black,
        ),
        Expanded(
          child: Column(
            children: [
              const Text("Khẩu phần"),
              Text(
                post.servers,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
        ),
        const VerticalDivider(
          endIndent: 5,
          indent: 5,
          thickness: 0.5,
          color: Colors.black,
        ),
        Expanded(
          child: Column(
            children: [
              const Text("Độ khó"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${post.level}/5",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  )
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}
