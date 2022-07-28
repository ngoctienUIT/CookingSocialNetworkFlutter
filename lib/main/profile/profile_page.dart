import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/profile/widget/item_follow.dart';
import 'package:cooking_social_network/main/profile/widget/list_post.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:cooking_social_network/setting/setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
          elevation: 1,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingPage(),
                        ),
                      );
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
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                                  (_) {
                            return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    width: 1, color: Colors.black));
                          }),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                      return const Icon(Icons.error);
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loadingPost();
                    }

                    myuser.User user = myuser.User.getDataFromSnapshot(
                        snapshot: snapshot.requireData);

                    return SizedBox(
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

  GridView loadingPost() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 2 / 3,
      ),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
