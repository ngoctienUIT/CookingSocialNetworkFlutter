import 'package:cooking_social_network/follow/view_follow.dart';
import 'package:flutter/material.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;

class ViewFollowPage extends StatefulWidget {
  const ViewFollowPage({Key? key, required this.index, this.user})
      : super(key: key);
  final int index;
  final myuser.User? user;

  @override
  State<ViewFollowPage> createState() => _ViewFollowPageState();
}

class _ViewFollowPageState extends State<ViewFollowPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
                controller: _tabController,
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.red,
                labelStyle: const TextStyle(fontSize: 16),
                tabs: const [
                  Tab(text: "Following"),
                  Tab(text: "Follower"),
                ]),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                ViewFollow(listFollow: widget.user!.following),
                ViewFollow(listFollow: widget.user!.followers)
              ]),
            )
          ],
        ),
      ),
    );
  }
}
