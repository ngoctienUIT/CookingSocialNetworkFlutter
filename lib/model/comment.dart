import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  List<String> favourites;
  String content;
  String userName;
  DateTime time;

  Comment(
      {required this.favourites,
      required this.content,
      required this.userName,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      "favourites": favourites,
      "content": content,
      "userName": userName,
      "time": time
    };
  }

  factory Comment.getDataFromMap({required DocumentSnapshot snapshot}) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Comment(
        favourites: (data["favourites"] as List<dynamic>)
            .map((favourite) => favourite.toString())
            .toList(),
        content: data["content"],
        userName: data["userName"],
        time: (data["time"] as Timestamp).toDate());
  }
}
