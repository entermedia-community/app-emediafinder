import 'package:em_mobile_flutter/views/WorkspaceSelect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//firebase log in code - Mando
class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password, BuildContext context}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WorkspaceSelect()));
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
