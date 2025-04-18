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

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Sign in with email and password
//   Future<void> signIn(String email, String password) async {
//     try {
//       Get.log('Attempting to sign in with email: $email');
//       // Sign out any existing user first
//       if (_auth.currentUser != null) {
//         await _auth.signOut();
//       }

//       // Perform sign-in
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password,
//       );
//       Get.log(
//         'Sign-in completed, userCredential: ${userCredential.toString()}',
//       );

//       // final user = userCredential.user;
//       if (userCredential.user == null) {
//         Get.log('User is null');
//         throw Exception('Authentication failed: No user returned');
//       }

//       Get.log(
//         'User signed in: ${userCredential.user!.uid}, email: ${userCredential.user!.email}',
//       );

//       // Check admin status
//       final isAdmin = await isAdminCheck(userCredential.user!.uid);
//       Get.log('Admin check result: $isAdmin');
//       if (!isAdmin) {
//         Get.log('User is not an admin: ${userCredential.user!.uid}');
//         await _auth.signOut();
//         throw Exception('Access denied: User is not an admin');
//       }

//       Get.log('User is an admin: ${userCredential.user!.uid}');
//     } on FirebaseAuthException catch (e) {
//       Get.log('Firebase Auth Error: ${e.code} - ${e.message}');
//       switch (e.code) {
//         case 'user-not-found':
//           throw Exception('No user found with this email');
//         case 'wrong-password':
//           throw Exception('Incorrect password');
//         case 'invalid-email':
//           throw Exception('Invalid email address');
//         case 'user-disabled':
//           throw Exception('This account has been disabled');
//         default:
//           throw Exception('Authentication failed: ${e.message}');
//       }
//     } catch (e, stackTrace) {
//       Get.log('Sign-in error: $e\nStackTrace: $stackTrace');
//       rethrow;
//     }
//   }

//   // Check if user is an admin
//   Future<bool> isAdminCheck(String uid) async {
//     try {
//       Get.log('Checking admin status for UID: $uid');
//       final doc = await _firestore.collection('admins').doc(uid).get();
//       final isAdmin = doc.exists;
//       Get.log('Admin check for $uid: $isAdmin');
//       return isAdmin;
//     } catch (e) {
//       Get.log('Error checking admin status: $e');
//       return false;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       Get.log('Signing out user');
//       await _auth.signOut();
//       Get.log('User signed out successfully');
//     } catch (e) {
//       Get.log('Sign-out error: $e');
//       rethrow;
//     }
//   }

//   // Get current user
//   User? get currentUser => _auth.currentUser;

//   // Stream for auth state changes
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();

//   // Check if user is admin
//   Future<bool> isAdmin(String uid) async {
//     try {
//       Get.log('Checking if user $uid is an admin');
//       final doc = await _firestore.collection('admins').doc(uid).get();
//       if (!doc.exists) {
//         Get.log('User $uid is not an admin');
//         return false;
//       }
//       Get.log('User $uid is an admin');
//       return true;
//     } catch (e) {
//       Get.log('Error checking admin status: $e');
//       return false;
//     }
//   }

//   // Sign in with email and password
//   Future<UserCredential?> signIn(String email, String password) async {
//     try {
//       Get.log('Attempting to sign in with email: $email');

//       // Sign out any existing user
//       if (_auth.currentUser != null) {
//         Get.log('Signing out existing user');
//         await _auth.signOut();
//       }

//       Get.log('Initiating sign in process');
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password,
//       );

//       if (userCredential.user == null) {
//         Get.log('User credential is null');
//         throw Exception('Authentication failed: User credential is null');
//       }

//       Get.log('User signed in successfully, checking admin status');
//       final uid = userCredential.user!.uid;
//       Get.log('User UID: $uid');

//       // Verify if the user is an admin
//       final isUserAdmin = await isAdmin(uid);
//       if (!isUserAdmin) {
//         Get.log('User is not an admin, signing out');
//         await _auth.signOut();
//         throw Exception('User is not authorized as admin');
//       }

//       Get.log('User is an admin, storing login state');
//       await _storage.write(key: 'isLoggedIn', value: 'true');
//       await _storage.write(key: 'userId', value: uid);

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       Get.log('Firebase Auth Error: ${e.code} - ${e.message}');
//       switch (e.code) {
//         case 'user-not-found':
//           throw Exception('No user found with this email');
//         case 'wrong-password':
//           throw Exception('Wrong password provided');
//         case 'invalid-email':
//           throw Exception('Invalid email address');
//         default:
//           throw Exception(e.message ?? 'Authentication failed');
//       }
//     } catch (e) {
//       Get.log('Error during sign in: $e');
//       throw Exception('An unexpected error occurred during sign in');
//     }
//   }
//   // Future<UserCredential> signIn(String email, String password) async {
//   //   try {
//   //     return await _auth.signInWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //   } catch (e) {
//   //     Get.log('Error during sign in: $e');
//   //     throw Exception('An unexpected error occurred during sign in');
//   //   }
//   // }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       Get.log('Signing out user');
//       await _auth.signOut();
//       await _storage.delete(key: 'isLoggedIn');
//       await _storage.delete(key: 'userId');
//       Get.log('User signed out successfully');
//     } catch (e) {
//       Get.log('Error during sign out: $e');
//       rethrow;
//     }
//   }

//   // Check if user is logged in
//   Future<bool> isLoggedIn() async {
//     try {
//       final isLoggedIn = await _storage.read(key: 'isLoggedIn');
//       final userId = await _storage.read(key: 'userId');
//       final currentUser = _auth.currentUser;

//       final isAuthenticated =
//           isLoggedIn == 'true' &&
//           userId != null &&
//           currentUser != null &&
//           userId == currentUser.uid;

//       Get.log('User login status: $isAuthenticated');
//       return isAuthenticated;
//     } catch (e) {
//       Get.log('Error checking login status: $e');
//       return false;
//     }
//   }
// }
