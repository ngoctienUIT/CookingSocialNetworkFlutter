import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/post/post_page/page/page1.dart';
import 'package:cooking_social_network/post/post_page/page/page2.dart';
import 'package:cooking_social_network/post/post_page/page/page3.dart';
import 'package:cooking_social_network/post/post_page/page/page4.dart';
import 'package:cooking_social_network/post/post_page/page/page5.dart';
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      cookingTime: 0,
      nameFood: "",
      level: 0.0,
      owner: FirebaseAuth.instance.currentUser!.email.toString(),
      servers: "",
      id: "",
      share: 0,
      time: DateTime.now());
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () async {
            if (_currentPage == 0) {
              bool exit = false;
              await showDialog(
                context: context,
                builder: (ctxt) => newDialog(action1: () {
                  exit = false;
                  Navigator.pop(context);
                }, action2: () {
                  exit = true;
                  Navigator.pop(context);
                }),
              );
              if (exit) {
                if (!mounted) return;
                Navigator.pop(context);
              }
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
                  onPressed: () async {
                    EasyLoading.show();
                    await PostRepository.posts(post);
                    EasyLoading.showSuccess("Thành công");
                    EasyLoading.dismiss();
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Đăng",
                    style: TextStyle(fontSize: 16),
                  ),
                )
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
        title: const Text(
          "Tạo công thức mới",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (_currentPage == 0) {
            bool exit = false;
            await showDialog(
              context: context,
              builder: (ctxt) => newDialog(action1: () {
                exit = false;
                Navigator.pop(context);
              }, action2: () {
                exit = true;
                Navigator.pop(context);
              }),
            );
            if (exit) {
              return Future.value(true);
            } else {
              return Future.value(false);
            }
          } else {
            setState(() {
              _currentPage--;
              _pageController.animateToPage(_currentPage,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            });
            return Future.value(false);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 3,
                child: Row(
                  children: List.generate(
                      5, (index) => Expanded(child: buildDot(index: index))),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Page1(post: post),
                    Page2(post: post),
                    Page3(post: post),
                    Page4(post: post),
                    Page5(post: post)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Dialog newDialog({required Function action1, required Function action2}) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 150,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Thoát?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Bạn thật sự muốn thoát?",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          action1();
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(fontSize: 16),
                        ))),
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          action2();
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(fontSize: 16),
                        )))
              ],
            )
          ],
        ),
      ),
    );
  }

  Container buildDot({required int index}) {
    return Container(
      height: 3,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
