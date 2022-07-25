import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/profile/your_profile_page.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:cooking_social_network/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSearch extends StatelessWidget {
  const UserSearch({Key? key, required this.query}) : super(key: key);
  final String query;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("info").get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Không có gì ở đây"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Info> listUser = snapshot.data!.docs
              .map(
                (doc) => Info.getDataFromSnapshot(snapshot: doc),
              )
              .toList()
              .where((user) =>
                  user.username.toLowerCase().contains(query.toLowerCase()) ||
                  user.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

          return ListView.builder(
              itemCount: listUser.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            YourProfilePage(userName: listUser[index].username),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          ClipOval(
                              child: Image.network(listUser[index].avatar,
                                  width: 50)),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(listUser[index].name),
                              Text(listUser[index].username)
                            ],
                          ),
                          const Spacer(),
                          FirebaseAuth.instance.currentUser!.email.toString() ==
                                  listUser[index].username
                              ? const SizedBox.shrink()
                              : StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("user")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email
                                          .toString())
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Text("Không có gì ở đây"));
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    myuser.User user =
                                        myuser.User.getDataFromSnapshot(
                                            snapshot: snapshot.requireData);

                                    return SizedBox(
                                      width: 120,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          UserRepository.followEvent(
                                              username:
                                                  listUser[index].username);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                        ),
                                        child: Text(user.following.contains(
                                                listUser[index].username)
                                            ? "Hủy Follow"
                                            : "Follow"),
                                      ),
                                    );
                                  })
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
