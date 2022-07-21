import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  List<String> post;
  List<String> favourites;
  List<String> followers;
  List<String> following;
  List<String> notify;

  User(
      {required this.favourites,
      required this.followers,
      required this.following,
      required this.notify,
      required this.post});

  factory User.getDataFromSnapshot({required DocumentSnapshot snapshot}) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
        favourites: (data["favourites"] as List<dynamic>)
            .map((favourite) => favourite.toString())
            .toList(),
        followers: (data["followers"] as List<dynamic>)
            .map((follower) => follower.toString())
            .toList(),
        following: (data["following"] as List<dynamic>)
            .map((follow) => follow.toString())
            .toList(),
        notify: (data["notify"] as List<dynamic>)
            .map((noti) => noti.toString())
            .toList(),
        post: (data["post"] as List<dynamic>)
            .map((posts) => posts.toString())
            .toList());
  }
}
