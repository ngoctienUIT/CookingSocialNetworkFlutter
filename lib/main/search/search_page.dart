import 'package:cooking_social_network/main/search/page/all_search.dart';
import 'package:cooking_social_network/main/search/page/post_search.dart';
import 'package:cooking_social_network/main/search/page/user_search.dart';
import 'package:cooking_social_network/main/search/search_view.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String search = "";
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 2,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () async {
                    var query = await showSearch(
                        context: context, delegate: SearchView(search: search));
                    setState(() {
                      search = query!;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 45,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(230, 230, 250, 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      search == "" ? "Tìm kiếm" : search,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: search == ""
                              ? const Color.fromRGBO(128, 128, 128, 1)
                              : Colors.black),
                    ),
                  ),
                ),
              ),
              search == ""
                  ? const SizedBox(height: 10)
                  : Container(
                      alignment: Alignment.center,
                      child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.red,
                          unselectedLabelColor: Colors.grey,
                          isScrollable: true,
                          indicatorColor: Colors.red,
                          tabs: const [
                            Tab(text: "Tất cả"),
                            Tab(text: "Người dùng"),
                            Tab(text: "Bài viết")
                          ]),
                    ),
            ],
          ),
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: [
            AllSearch(),
            UserSearch(query: search),
            PostSearch(query: search)
          ],
        ))
      ],
    );
  }
}
