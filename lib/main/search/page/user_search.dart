import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/search/widget/item_user.dart';
import 'package:cooking_social_network/main/search/widget/loading_user.dart';
import 'package:cooking_social_network/model/info.dart';
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
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return loadingUser();
              },
            );
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
            itemBuilder: (context, index) => itemUser(context, listUser[index]),
          );
        });
  }
}
