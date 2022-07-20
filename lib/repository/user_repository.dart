import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/post.dart';
import 'package:cooking_social_network/model/user.dart' as myusser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum UserState {
  userNotFound,
  wrongPassword,
  success,
  weakPassword,
  emailUse,
  error
}

class UserRepository {
  static Future<UserState> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return UserState.userNotFound;
      } else if (e.code == 'wrong-password') {
        return UserState.wrongPassword;
      }
    } catch (_) {
      return UserState.error;
    }
    return UserState.success;
  }

  static Future<UserState> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return UserState.weakPassword;
      } else if (e.code == 'email-already-in-use') {
        return UserState.emailUse;
      }
    } catch (_) {
      return UserState.error;
    }
    return UserState.success;
  }

  static Future<UserState> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    return UserState.success;
  }

  static Future<UserState> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    return UserState.success;
  }

  static bool isSignIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static Future initData(Info infoUser) async {
    Map<String, dynamic> user = {
      "favourites": [],
      "followers": [],
      "following": [],
      "notify": [],
      "post": [],
    };

    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .set(user);

    String linkAvatar =
        "https://firebasestorage.googleapis.com/v0/b/cooking-social-network-flutter.appspot.com/o/avatar%2Fcooking.png?alt=media&token=29e94202-4a5a-40db-b7de-543bd53621a6";

    if (infoUser.avatar != '') {
      linkAvatar = await uploadImage(infoUser.avatar, "avatar",
          FirebaseAuth.instance.currentUser!.email.toString());
    }

    Map<String, dynamic> info = {
      "avatar": linkAvatar,
      "birthday": infoUser.birthday,
      "description": infoUser.description,
      "gender": infoUser.gender,
      "name": infoUser.name
    };

    await FirebaseFirestore.instance
        .collection("info")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .set(info);
  }

  static Future<bool> checkInfo() async {
    bool check = false;
    await FirebaseFirestore.instance
        .collection("info")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get()
        .then((value) {
      if (value.exists) {
        check = true;
      }
    });
    return check;
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
      myusser.User user = myusser.User.getDataFromSnapshot(snapshot: value);
      user.post.add(id);
      FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .update({"post": user.post});
    });
  }

  static Stream<DocumentSnapshot> getInfoUser({required String username}) {
    return FirebaseFirestore.instance
        .collection("info")
        .doc(username)
        .snapshots();
  }

  static Stream<DocumentSnapshot> getDataUser({required String username}) {
    return FirebaseFirestore.instance
        .collection("user")
        .doc(username)
        .snapshots();
  }

  static Stream<DocumentSnapshot> getDataComment({required String id}) {
    return FirebaseFirestore.instance.collection("comment").doc(id).snapshots();
  }

  static Stream<DocumentSnapshot> getDataPost({required String id}) {
    return FirebaseFirestore.instance.collection("post").doc(id).snapshots();
  }
}
