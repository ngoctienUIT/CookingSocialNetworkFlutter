import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/main/notify/widget/notify_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllNotify extends StatelessWidget {
  const AllNotify({Key? key}) : super(key: key);

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.requireData.data() as Map<String, dynamic>;
          List<String> notify = (data["notify"] as List<dynamic>)
              .map((noti) => noti.toString())
              .toList();
          return ListView.builder(
            itemCount: notify.length,
            itemBuilder: (context, index) => notifyItem(id: notify[index]),
          );
        });
  }
}
