import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/login/login_page.dart';
import 'package:cooking_social_network/main/profile/widget/item_follow.dart';
import 'package:cooking_social_network/main/profile/widget/list_post.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
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
        stream: UserRepository.getInfoUser(
            username: FirebaseAuth.instance.currentUser!.email.toString()),
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
    return Column(
      children: [
        Material(
          elevation: 0.5,
          child: Container(
            decoration: const BoxDecoration(),
            height: 55,
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    info == null ? "name" : info.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: TextButton(
                    onPressed: () async {
                      await UserRepository.logout();
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false);
                    },
                    child: const Icon(Icons.menu, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                        : Image.network(info.avatar, width: 150, height: 150),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    info == null
                        ? "@username"
                        : FirebaseAuth.instance.currentUser!.email.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<DocumentSnapshot>(
                      stream: UserRepository.getDataUser(
                          username: FirebaseAuth.instance.currentUser!.email
                              .toString()),
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
                  const SizedBox(height: 5),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Edit Profile")),
                  const SizedBox(height: 5),
                  Text(info == null ? "mô ta" : info.description),
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
                  stream: UserRepository.getDataUser(
                      username:
                          FirebaseAuth.instance.currentUser!.email.toString()),
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
                    return Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: TabBarView(controller: _tabController, children: [
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
    );
  }
}
