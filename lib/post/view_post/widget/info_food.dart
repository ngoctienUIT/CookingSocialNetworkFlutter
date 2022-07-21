import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/view_post/page/comment_page.dart';
import 'package:cooking_social_network/post/view_post/page/info_food_page.dart';
import 'package:cooking_social_network/post/view_post/page/ingredient_page.dart';
import 'package:cooking_social_network/post/view_post/page/method_page.dart';
import 'package:flutter/material.dart';

class InfoFood extends StatefulWidget {
  const InfoFood({Key? key, this.post}) : super(key: key);
  final Post? post;

  @override
  State<InfoFood> createState() => _InfoFoodState();
}

class _InfoFoodState extends State<InfoFood> with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          widget.post == null ? "name" : widget.post!.nameFood,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(
          thickness: 0.5,
          endIndent: 20,
          indent: 20,
          color: Colors.black,
        ),
        Container(
          alignment: Alignment.center,
          child: TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              indicatorColor: Colors.red,
              tabs: const [
                Tab(text: "Thông tin"),
                Tab(text: "Nguyên liệu"),
                Tab(text: "Cách làm"),
                Tab(text: "Bình luận"),
              ]),
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            widget.post == null
                ? const Text("không có gì ở đây")
                : InfoFoodPage(
                    post: widget.post,
                    action: () {
                      _tabController.animateTo(3);
                    }),
            widget.post == null
                ? const Text("không có gì ở đây")
                : IngredientPage(post: widget.post),
            widget.post == null
                ? const Text("không có gì ở đây")
                : MethodPage(post: widget.post),
            widget.post == null
                ? const Text("không có gì ở đây")
                : CommentPage(post: widget.post)
          ]),
        )
      ],
    );
  }
}
