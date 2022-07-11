import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum UserState { userNotFound, wrongPassword, success, error }

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
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
}
