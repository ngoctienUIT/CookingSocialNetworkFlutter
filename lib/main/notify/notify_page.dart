import 'package:cooking_social_network/main/notify/page/show_notify.dart';
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
        Material(
          elevation: 1,
          child: Container(
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
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              ShowNotify(),
              ShowNotify(type: "favourist"),
              ShowNotify(type: "comment"),
              ShowNotify(type: "follow")
            ],
          ),
        )
      ],
    );
  }
}
