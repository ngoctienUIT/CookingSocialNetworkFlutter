import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/notify/widget/loading_notify.dart';
import 'package:cooking_social_network/main/notify/widget/notify_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowNotify extends StatelessWidget {
  const ShowNotify({Key? key, this.type}) : super(key: key);
  final String? type;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notification")
            .doc(FirebaseAuth.instance.currentUser!.email.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Icon(Icons.error);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => loadingNotify());
          }
          List<String> notify = [];
          if (snapshot.requireData.exists) {
            var data = snapshot.requireData.data() as Map<String, dynamic>;
            notify = (data["notify"] as List<dynamic>)
                .map((noti) => noti.toString())
                .toList()
                .reversed
                .toList();
          }
          return ListView.builder(
            itemCount: notify.length,
            itemBuilder: (context, index) =>
                notifyItem(id: notify[index], type: type),
          );
        });
  }
}
