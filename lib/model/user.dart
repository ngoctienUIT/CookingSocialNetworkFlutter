import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  List<dynamic> post;
  List<dynamic> favourites;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> notify;

  User(
      {required this.favourites,
      required this.followers,
      required this.following,
      required this.notify,
      required this.post});

  factory User.getDataFromSnapshot({required DocumentSnapshot snapshot}) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
        favourites: data["favourites"],
        followers: data["followers"],
        following: data["following"],
        notify: data["notify"],
        post: data["post"]);
  }
}
