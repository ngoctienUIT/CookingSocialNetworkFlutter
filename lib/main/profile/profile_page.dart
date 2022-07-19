import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/login/login_page.dart';
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

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: UserRepository.getInfoUser(
            username: FirebaseAuth.instance.currentUser!.email.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          var info = Info.getDataFromSnapshot(snapshot: snapshot.requireData);
          return body(context: context, info: info);
        });
  }

  Column body({required BuildContext context, required Info info}) {
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
                    info.name,
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
        const SizedBox(height: 10),
        ClipOval(
          child: Image.network(
            info.avatar,
            width: 150,
            height: 150,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          FirebaseAuth.instance.currentUser!.email.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        StreamBuilder<DocumentSnapshot>(
            stream: UserRepository.getDataUser(
                username: FirebaseAuth.instance.currentUser!.email.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
              // bool checkLoading =
              //     snapshot.connectionState == ConnectionState.waiting;
              myuser.User user = myuser.User.getDataFromSnapshot(
                  snapshot: snapshot.requireData);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemProfile(user.following.length, "following"),
                  const SizedBox(width: 20),
                  itemProfile(user.followers.length, "follower"),
                  const SizedBox(width: 20),
                  itemProfile(user.post.length, "post")
                ],
              );
            }),
        const SizedBox(height: 5),
        ElevatedButton(onPressed: () {}, child: const Text("Edit Profile")),
        const SizedBox(height: 5),
        const Text("mô ta"),
        const Divider(
          thickness: 1,
          color: Color.fromARGB(255, 237, 232, 232),
        ),
        const Expanded(child: Text("abc"))
      ],
    );
  }

  Column itemProfile(int number, String text) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 15),
        )
      ],
    );
  }
}
