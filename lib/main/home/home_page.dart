import 'package:cooking_social_network/main/home/page/follow_post.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(child: Container()),
        Positioned(
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(65, 216, 197, 1),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Wellcome to Cooking",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(102, 226, 211, 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: TabBar(
                        controller: _tabController,
                        labelColor: const Color.fromRGBO(45, 216, 198, 1),
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        unselectedLabelColor: Colors.white,
                        unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15),
                        isScrollable: false,
                        indicatorColor: Colors.red,
                        indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        tabs: const [
                          Tab(text: "Mới nhất"),
                          Tab(text: "Phổ biến"),
                          Tab(text: "Theo dõi")
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 150,
          bottom: 0,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: TabBarView(
              controller: _tabController,
              children: const [Text("data"), Text("data"), FollowPost()],
            ),
          ),
        )
      ],
    );
  }
}
