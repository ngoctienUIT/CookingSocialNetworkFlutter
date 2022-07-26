import 'package:cooking_social_network/main/notify/page/all_notify.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({Key? key}) : super(key: key);

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: TabBar(
              controller: _tabController,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              indicatorColor: Colors.red,
              tabs: const [
                Tab(text: "Tất cả"),
                Tab(text: "Yêu thích"),
                Tab(text: "Bình luận"),
                Tab(text: "Theo dõi")
              ]),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              AllNotify(),
              Text("Yêu thích"),
              Text("Bình luận"),
              Text("Theo dõi")
            ],
          ),
        )
      ],
    );
  }
}
