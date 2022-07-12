import 'package:cloud_firestore/cloud_firestore.dart';
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

  static void initData() async {
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

    Map<String, dynamic> info = {
      "avatar": "",
      "birthday": "",
      "description": "",
      "gender": "",
      "name": ""
    };

    await FirebaseFirestore.instance
        .collection("info")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .set(info);
  }
}