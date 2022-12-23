import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  user? _userFromFirebase(User u) {
    return u == null ? null : user(userId: u.uid);
  }

//signin with email and password
  Future SignInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      print("User Signed in");
      return _userFromFirebase(firebaseUser!);
    } catch (e) {
      print(e);
    }
  }

  //singup with email and password
  Future SignUpWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      return _userFromFirebase(firebaseUser!);
    } catch (e) {
      print(e);
    }
  }

//reset password
  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}

class user {
  String userId;
  user({required this.userId});
}
