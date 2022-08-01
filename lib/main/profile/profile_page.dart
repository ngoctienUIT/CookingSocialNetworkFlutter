import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/generated/l10n.dart';
import 'package:cooking_social_network/main/profile/widget/item_follow.dart';
import 'package:cooking_social_network/main/profile/widget/list_post.dart';
import 'package:cooking_social_network/main/profile/widget/loading_post.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:cooking_social_network/setting/page/profile_setting.dart';
import 'package:cooking_social_network/setting/setting_page.dart';
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
                          return itemFollow(user: null, context: context);
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return itemFollow(user: null, context: context);
                        }
                        myuser.User user = myuser.User.getDataFromSnapshot(
                            snapshot: snapshot.requireData);
                        return itemFollow(user: user, context: context);
                      }),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileSetting(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                                  (_) {
                            return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    width: 1, color: Colors.black));
                          }),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      child: Text(
                        S.current.editProfile,
                        style: const TextStyle(color: Colors.black),
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
                    double height;
                    switch (_tabController.index) {
                      case 0:
                        height = user.post.length.toDouble();
                        break;
                      case 1:
                        height = user.favourites.length.toDouble();
                        break;
                      default:
                        height = user.post.length.toDouble();
                    }

                    height = (height % 3 == 0 ? height / 3 : (height / 3) + 1) *
                        (MediaQuery.of(context).size.width / 3) *
                        1.6;

                    if (height == 0) {
                      height = 100;
                    }

                    return SizedBox(
                      height: height,
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
