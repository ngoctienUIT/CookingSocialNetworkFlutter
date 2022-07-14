import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/post_page/page/page1.dart';
import 'package:cooking_social_network/post/post_page/page/page2.dart';
import 'package:cooking_social_network/post/post_page/page/page3.dart';
import 'package:cooking_social_network/post/post_page/page/page4.dart';
import 'package:cooking_social_network/post/post_page/page/page5.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int _currentPage = 0;
  Post post = Post(
      comments: [],
      favourites: [],
      images: [],
      ingredients: [],
      methods: [],
      description: "",
      cookingTime: "",
      nameFood: "",
      level: 0.0,
      owner: "",
      servers: "",
      share: 0);
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            if (_currentPage == 0) {
              Navigator.pop(context);
            } else {
              setState(() {
                _currentPage--;
                _pageController.animateToPage(_currentPage,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              });
            }
          },
          icon: _currentPage == 0
              ? const Icon(
                  Icons.close_rounded,
                  color: Colors.red,
                )
              : const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        actions: [
          _currentPage == 4
              ? TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("post")
                        .doc("abcde")
                        .set(post.toMap());
                  },
                  child: const Text("Đăng"))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _currentPage++;
                      _pageController.animateToPage(_currentPage,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    });
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                ),
        ],
        title: Text(
          "Post Page $_currentPage",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Page1(post: post),
            Page2(post: post),
            const Page3(),
            Page4(),
            const Page5()
          ],
        ),
      ),
    );
  }
}
