import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/notify.dart';

class NotifyRepository {
  static Future addNotify(
      {required Notify notify, required String username}) async {
    var firestore = FirebaseFirestore.instance.collection("notify").doc();
    await firestore.set(notify.toMap());
    FirebaseFirestore.instance
        .collection("notification")
        .doc(username)
        .get()
        .then((value) {
      List<String> listNotify = [];
      if (value.exists) {
        var data = value.data() as Map<String, dynamic>;
        listNotify = (data["notify"] as List<dynamic>)
            .map((noti) => noti.toString())
            .toList();
      }
      listNotify.add(firestore.id);
      if (value.exists) {
        FirebaseFirestore.instance
            .collection("notification")
            .doc(username)
            .update({"notify": listNotify});
      } else {
        FirebaseFirestore.instance
            .collection("notification")
            .doc(username)
            .set({"notify": listNotify});
      }
    });
  }

  static Future removeNotify(
      {required Notify notify, required String username}) async {
    FirebaseFirestore.instance
        .collection("notify")
        .where("content", isEqualTo: notify.content)
        .where("id", isEqualTo: notify.id)
        .where("type", isEqualTo: notify.type)
        .where("user", isEqualTo: notify.user)
        .get()
        .then((valueDoc) async {
      Notify notifyMin = Notify.getDataFromSnapshot(snapshot: valueDoc.docs[0]);
      var docNotify = valueDoc.docs[0];
      if (notify.type != "follow") {
        for (var doc in valueDoc.docs) {
          Notify newNotify = Notify.getDataFromSnapshot(snapshot: doc);
          if (notifyMin.time.difference(notify.time).inMilliseconds >
              newNotify.time.difference(notify.time).inMilliseconds) {
            docNotify = doc;
          }
        }
      } else {
        await FirebaseFirestore.instance
            .collection("notification")
            .doc(username)
            .get()
            .then((value) {
          var data = value.data() as Map<String, dynamic>;
          List<String> listNotify = (data["notify"] as List<dynamic>)
              .map((noti) => noti.toString())
              .toList();
          for (var doc in valueDoc.docs) {
            if (listNotify.contains(doc.id)) {
              docNotify = doc;
              break;
            }
          }
        });
      }

      FirebaseFirestore.instance
          .collection("notify")
          .doc(docNotify.id)
          .delete();

      FirebaseFirestore.instance
          .collection("notification")
          .doc(username)
          .get()
          .then((value) {
        var data = value.data() as Map<String, dynamic>;
        List<String> listNotify = (data["notify"] as List<dynamic>)
            .map((noti) => noti.toString())
            .toList();
        listNotify.remove(docNotify.id);
        FirebaseFirestore.instance
            .collection("notification")
            .doc(username)
            .update({"notify": listNotify});
      });
    });
  }
}
