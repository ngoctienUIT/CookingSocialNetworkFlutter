import 'package:cloud_firestore/cloud_firestore.dart';

class Info {
  String name;
  int gender;
  String birthday;
  String description;
  String avatar;

  Info(
      {required this.name,
      required this.birthday,
      required this.gender,
      required this.description,
      required this.avatar});

  @override
  String toString() {
    return "$name $birthday $gender $description $avatar";
  }

  factory Info.getDataFromSnapshot({required DocumentSnapshot snapshot}) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Info(
        name: data["name"],
        birthday: data["birthday"],
        gender: data["gender"],
        description: data["description"],
        avatar: data["avatar"]);

    // return Info(
    //     name: "name",
    //     birthday: "birthday",
    //     gender: 0,
    //     description: "description",
    //     avatar: "avatar");
  }
}
