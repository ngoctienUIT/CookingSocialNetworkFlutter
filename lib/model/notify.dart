import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Notify extends Equatable {
  final String content;
  final String id;
  final String user;
  final int status;
  final DateTime time;
  final String type;

  const Notify(
      {required this.content,
      required this.id,
      required this.user,
      required this.status,
      required this.time,
      required this.type});

  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "id": id,
      "user": user,
      "status": status,
      "time": time,
      "type": type
    };
  }

  factory Notify.getDataFromSnapshot({required DocumentSnapshot snapshot}) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Notify(
        content: data["content"],
        id: data["id"],
        user: data["user"],
        status: data["status"],
        time: (data["time"] as Timestamp).toDate(),
        type: data["type"]);
  }

  @override
  List<Object?> get props => [content, id, user, time, type];
}
