import 'package:cooking_social_network/login/login_page.dart';
import 'package:flutter/material.dart';
import 'body_onboarding_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> data = [
    {
      "title": "Bài viết",
      "text": "Bạn có thể đăng tải và xem các bài viết về món ăn",
      "image": "assets/images/intro1.gif"
    },
    {
      "title": "Tìm kiếm",
      "text": "Tìm kiếm những món ăn mà bạn yêu thích",
      "image": "assets/images/intro2.gif"
    },
    {
      "title": "Trang cá nhân",
      "text": "Xây dựng trang cá nhân của riêng bạn",
      "image": "assets/images/intro3.gif"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: 3,
                  controller: _pageController,
                  itemBuilder: (context, index) => BodyOnboardingScreen(
                    data: data[index],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          "Skip",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: List.generate(
                            data.length, (index) => buildDot(index: index)),
                      ),
                      const Spacer(),
                      nextButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextButton nextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (currentPage < 2) {
          setState(() {
            currentPage++;
            _pageController.animateToPage(currentPage,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      },
      child: Text(
        currentPage != 2 ? "Next" : "Login",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 6,
      width: currentPage == index ? 20 : 6,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
