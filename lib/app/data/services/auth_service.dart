import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // login
  Future<User?> logIn(String email, String password) async {
    try {
      Get.log('Attempting login with email:$email');
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      Get.log('authentication error:$e');
      return null;
    }
  }

  // logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentuser => _auth.currentUser;
}
