import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/comment.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:firebase_storage/firebase_storage.dart';

class PostRepository {
  static Future<bool> checkFavourite({required String id}) async {
    bool check = true;
    await FirebaseFirestore.instance
        .collection("post")
        .doc(id)
        .get()
        .then((snapshot) {
      Post post = Post.getDataFromSnapshot(snapshot: snapshot);
      check = post.favourites
          .contains(FirebaseAuth.instance.currentUser!.email.toString());
    });
    return check;
  }

  static Future favouriteEvent({required String id}) async {
    List<String> favouritesPost = [];
    List<String> favouritesUser = [];

    await FirebaseFirestore.instance
        .collection("post")
        .doc(id)
        .get()
        .then((snapshot) {
      Post post = Post.getDataFromSnapshot(snapshot: snapshot);
      favouritesPost = post.favourites;
    });
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get()
        .then((snapshot) {
      myuser.User user = myuser.User.getDataFromSnapshot(snapshot: snapshot);
      favouritesUser = user.favourites;
    });
    if (await checkFavourite(id: id)) {
      favouritesPost
          .remove(FirebaseAuth.instance.currentUser!.email.toString());
      favouritesUser.remove(id);
    } else {
      favouritesPost.add(FirebaseAuth.instance.currentUser!.email.toString());
      favouritesUser.add(id);
    }

    await FirebaseFirestore.instance
        .collection("post")
        .doc(id)
        .update({"favourites": favouritesPost});

    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .update({"favourites": favouritesUser});
  }

  static Stream<DocumentSnapshot> getDataComment({required String id}) {
    return FirebaseFirestore.instance.collection("comment").doc(id).snapshots();
  }

  static Stream<DocumentSnapshot> getDataPost({required String id}) {
    return FirebaseFirestore.instance.collection("post").doc(id).snapshots();
  }

  static Future<String> uploadImage(
      String link, String folder, String uuid) async {
    final upload = FirebaseStorage.instance.ref().child("$folder/$uuid");

    await upload.putFile(File(link));
    return await upload.getDownloadURL();
  }

  static Future posts(Post post) async {
    List<String> imageList = [];
    var firestore = FirebaseFirestore.instance.collection("post").doc();
    post.id = firestore.id;
    for (int i = 0; i < post.images.length; i++) {
      String link = await uploadImage(
          post.images[i], "post/${firestore.id}", i.toString());
      imageList.add(link);
    }
    post.images = imageList;

    for (int i = 0; i < post.methods.length; i++) {
      String link = await uploadImage(
          post.methods[i].image, "method/${firestore.id}", i.toString());
      post.methods[i].image = link;
    }
    firestore.set(post.toMap());
    addPostUser(firestore.id);
  }

  static void addPostUser(String id) {
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get()
        .then((value) {
      myuser.User user = myuser.User.getDataFromSnapshot(snapshot: value);
      user.post.add(id);
      FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .update({"post": user.post});
    });
  }

  static Future addComment(
      {required String id, required String content}) async {
    Comment comment = Comment(
        favourites: [],
        content: content,
        userName: FirebaseAuth.instance.currentUser!.email.toString(),
        time: DateTime.now());

    var firestore = FirebaseFirestore.instance.collection("comment").doc();
    firestore.set(comment.toMap());
    FirebaseFirestore.instance
        .collection("post")
        .doc(id)
        .get()
        .then((snapshot) {
      Post post = Post.getDataFromSnapshot(snapshot: snapshot);
      post.comments.add(firestore.id);
      FirebaseFirestore.instance
          .collection("post")
          .doc(id)
          .update({"comments": post.comments});
    });
  }

  static Future<bool> checkFavouristComment({required String id}) async {
    bool check = true;
    await FirebaseFirestore.instance
        .collection("comment")
        .doc(id)
        .get()
        .then((snapshot) {
      Comment comment = Comment.getDataFromMap(snapshot: snapshot);
      check = comment.favourites
          .contains(FirebaseAuth.instance.currentUser!.email.toString());
    });
    return check;
  }

  static Future favouristComment({required String id}) async {
    List<String> favourist = [];
    await FirebaseFirestore.instance
        .collection("comment")
        .doc(id)
        .get()
        .then((snapshot) {
      Comment comment = Comment.getDataFromMap(snapshot: snapshot);
      favourist = comment.favourites;
    });

    if (await checkFavouristComment(id: id)) {
      favourist.remove(FirebaseAuth.instance.currentUser!.email.toString());
    } else {
      favourist.add(FirebaseAuth.instance.currentUser!.email.toString());
    }

    FirebaseFirestore.instance
        .collection("comment")
        .doc(id)
        .update({"favourites": favourist});
  }

  static String daysBetween(
      {required DateTime dateTime1, required DateTime dateTime2}) {
    String time = "";
    var dateTime = dateTime2.difference(dateTime1);
    if (dateTime.inSeconds == 0) {
      time = "Vừa xong";
    } else if (dateTime.inSeconds < 60) {
      time = "${dateTime.inSeconds} giây";
    } else if (dateTime.inMinutes < 60) {
      time = "${dateTime.inMinutes} phút";
    } else if (dateTime.inHours < 24) {
      time = "${dateTime.inHours} giờ";
    } else if (dateTime.inDays < 7) {
      time = "${dateTime.inDays} ngày";
    } else if (dateTime.inDays < 30) {
      time = "${dateTime.inDays / 7} tuần";
    } else if (dateTime.inDays >= 30 && dateTime.inDays < 365) {
      time = "${dateTime.inDays / 30} tháng";
    } else if (dateTime.inDays >= 365) {
      time = "${dateTime.inDays / 365} năm";
    }
    return time;
  }
}
