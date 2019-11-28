import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  //SINGLETON
  static final AuthRepository _authRepository = new AuthRepository._internal();
  factory AuthRepository() => _authRepository;
  AuthRepository._internal();
  //END SINGLETON

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUserId() async {
    return (await _firebaseAuth.currentUser()).uid;
  }
}