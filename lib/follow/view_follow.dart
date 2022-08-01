import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/search/widget/item_user.dart';
import 'package:cooking_social_network/main/search/widget/loading_user.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:flutter/material.dart';

class ViewFollow extends StatelessWidget {
  const ViewFollow({Key? key, required this.listFollow}) : super(key: key);
  final List<String> listFollow;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listFollow.length,
      itemBuilder: (context, index) => FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("info")
              .doc(listFollow[index])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Icon(Icons.error);
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingUser();
            }

            Info info =
                Info.getDataFromSnapshot(snapshot: snapshot.requireData);
            return itemUser(context, info);
          }),
    );
  }
}
