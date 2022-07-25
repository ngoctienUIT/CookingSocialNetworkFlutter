import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooking_social_network/model/info.dart';
import 'package:cooking_social_network/model/user.dart' as myuser;
import 'package:cooking_social_network/repository/post_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      linkAvatar = await PostRepository.uploadImage(infoUser.avatar, "avatar",
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

  static Future<bool> checkFollow({required String username}) async {
    bool check = true;
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get()
        .then((snapshot) {
      myuser.User user = myuser.User.getDataFromSnapshot(snapshot: snapshot);
      check = user.following.contains(username);
    });
    return check;
  }

  static Future followEvent({required String username}) async {
    List<String> myFollow = [];
    List<String> yourFollow = [];

    await FirebaseFirestore.instance
        .collection("user")
        .doc(username)
        .get()
        .then((snapshot) {
      myuser.User user = myuser.User.getDataFromSnapshot(snapshot: snapshot);
      yourFollow = user.followers;
    });
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get()
        .then((snapshot) {
      myuser.User user = myuser.User.getDataFromSnapshot(snapshot: snapshot);
      myFollow = user.following;
    });
    if (await checkFollow(username: username)) {
      yourFollow.remove(FirebaseAuth.instance.currentUser!.email.toString());
      myFollow.remove(username);
    } else {
      yourFollow.add(FirebaseAuth.instance.currentUser!.email.toString());
      myFollow.add(username);
    }

    await FirebaseFirestore.instance
        .collection("user")
        .doc(username)
        .update({"followers": yourFollow});

    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .update({"following": myFollow});
  }
}
