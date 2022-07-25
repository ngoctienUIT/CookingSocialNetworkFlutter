import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryRepository {
  static Stream<DocumentSnapshot> getDataHistory() {
    return FirebaseFirestore.instance
        .collection("history")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .snapshots();
  }

  static Future updateHistory({required String search}) async {
    FirebaseFirestore.instance
        .collection("history")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get()
        .then((history) {
      var data = history.data() as Map<String, dynamic>;
      List<String> listHistory = (data["history"] as List<dynamic>)
          .map((history) => history.toString())
          .toList();
      listHistory.remove(search);
      listHistory.add(search);
      FirebaseFirestore.instance
          .collection("history")
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .update({"history": listHistory});
    });
  }
}
