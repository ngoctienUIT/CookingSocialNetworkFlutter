import 'package:cooking_social_network/main/home/home_page.dart';
import 'package:cooking_social_network/main/notify/notify_page.dart';
import 'package:cooking_social_network/main/profile/profile_page.dart';
import 'package:cooking_social_network/main/search/search_page.dart';
import 'package:cooking_social_network/post/post_page/post_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const FaIcon(
          FontAwesomeIcons.plus,
          size: 25,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostPage(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomAppBar(),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
            child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemCount: 4,
          itemBuilder: (context, index) => getPage(),
        )),
      ),
    );
  }

  //Hàm trả về các page khi người dùng chọn
  Widget getPage() {
    if (_currentPage == 0) {
      return const HomePage();
    } else if (_currentPage == 1) {
      return const SearchPage();
    } else if (_currentPage == 2) {
      return const NotifyPage();
    }
    return const ProfilePage();
  }

  BottomAppBar customBottomAppBar() {
    return BottomAppBar(
      color: Colors.green,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            iconBottom(Icons.home_rounded, Icons.home_outlined, 0),
            const Spacer(),
            iconBottom(FontAwesomeIcons.magnifyingGlass, Icons.search, 1),
            const Spacer(
              flex: 3,
            ),
            iconBottom(Icons.notifications, Icons.notifications_outlined, 2),
            const Spacer(),
            iconBottom(Icons.person, Icons.person_outline, 3),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  IconButton iconBottom(IconData iconData1, IconData iconData2, int index) {
    return IconButton(
      enableFeedback: true,
      onPressed: () {
        setState(() {
          _currentPage = index;
          _pageController.jumpToPage(_currentPage);
        });
      },
      icon: Icon(
        _currentPage == index ? iconData1 : iconData2,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Nhấn thêm lần nữa để thoát");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
