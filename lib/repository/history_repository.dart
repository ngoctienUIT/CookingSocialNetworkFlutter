import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryRepository {
  static Stream<DocumentSnapshot> getDataHistory() {
    return FirebaseFirestore.instance
        .collection("history")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .snapshots();
  }
}
