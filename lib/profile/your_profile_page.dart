import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/profile/widget/item_follow.dart';
import 'package:cooking_social_network/main/profile/widget/list_post.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;

class YourProfilePage extends StatefulWidget {
  const YourProfilePage({Key? key, required this.userName}) : super(key: key);
  final String userName;

  @override
  State<YourProfilePage> createState() => _YourProfilePageState();
}

class _YourProfilePageState extends State<YourProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: UserRepository.getInfoUser(username: widget.userName),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return body(context: context, info: null);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return body(context: context, info: null);
          }
          var info = Info.getDataFromSnapshot(snapshot: snapshot.requireData);
          return body(context: context, info: info);
        });
  }

  Widget body({required BuildContext context, Info? info}) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          info == null ? "name" : info.name,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 10),
                Column(
                  children: [
                    ClipOval(
                      child: info == null
                          ? Image.asset("assets/images/cooking.png",
                              width: 150, height: 150)
                          : CachedNetworkImage(
                              imageUrl: info.avatar,
                              width: 150,
                              height: 150,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      info == null ? "@username" : widget.userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<DocumentSnapshot>(
                        stream: UserRepository.getDataUser(
                            username: widget.userName),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return itemFollow(user: null);
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return itemFollow(user: null);
                          }
                          myuser.User user = myuser.User.getDataFromSnapshot(
                              snapshot: snapshot.requireData);
                          return itemFollow(user: user);
                        }),
                    const SizedBox(height: 10),
                    StreamBuilder<DocumentSnapshot>(
                        stream: UserRepository.getDataUser(
                            username: FirebaseAuth.instance.currentUser!.email
                                .toString()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Không có gì ở đây"),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          myuser.User user = myuser.User.getDataFromSnapshot(
                              snapshot: snapshot.requireData);
                          return SizedBox(
                            width: 150,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                UserRepository.followEvent(
                                    username: widget.userName);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                              child: Text(
                                user.following.contains(widget.userName)
                                    ? "Hủy Follow"
                                    : "Follow",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 10),
                    Text(info == null ? "mô tả" : info.description),
                  ],
                ),
                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 237, 232, 232),
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
                        Tab(icon: Icon(Icons.apps_rounded)),
                        Tab(icon: Icon(Icons.favorite_rounded)),
                        Tab(icon: Icon(Icons.lock_outline_rounded))
                      ]),
                ),
                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 237, 232, 232),
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream:
                        UserRepository.getDataUser(username: widget.userName),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Không có gì ở đây"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      myuser.User user = myuser.User.getDataFromSnapshot(
                          snapshot: snapshot.requireData);
                      return SizedBox(
                        height: double.maxFinite,
                        child:
                            TabBarView(controller: _tabController, children: [
                          listPost(user: user, index: 0),
                          listPost(user: user, index: 1),
                          listPost(user: user, index: 2)
                        ]),
                      );
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
