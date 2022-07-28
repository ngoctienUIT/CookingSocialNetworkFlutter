import 'package:cloud_firestore/cloud_firestore.dart';

class Info {
  String name;
  int gender;
  String birthday;
  String description;
  String avatar;
  String username;

  Info(
      {required this.name,
      required this.birthday,
      required this.gender,
      required this.description,
      required this.avatar,
      required this.username});

  factory Info.getDataFromSnapshot({required DocumentSnapshot snapshot}) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Info(
        name: data["name"],
        birthday: data["birthday"],
        gender: data["gender"],
        description: data["description"],
        avatar: data["avatar"],
        username: snapshot.id);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "birthday": birthday,
      "gender": gender,
      "description": description,
      "avatar": avatar
    };
  }
}
