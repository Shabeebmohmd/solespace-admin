import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/data/services/auth_service.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isPasswordVisible = true.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _authService.currentuser;
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      await Future.delayed(const Duration(seconds: 2));
      if (user != null) {
        if (user.email == 'shabeebmohmd47@gmail.com') {
          Get.offAllNamed(AppRoutes.home);
          // Get.snackbar('Success', 'Welcome');
        } else {
          Get.snackbar('Access denied', 'You are not admin');
          logOut();
        }
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  Future<void> logIn(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _authService.logIn(email, password);
      if (user != null) {
        if (user.email == 'shabeebmohmd47@gmail.com') {
          Get.snackbar('Success', 'Welcome');
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.snackbar('Error', 'Invalid credential');
        }
      }
    } catch (e) {
      log('e:$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    await _authService.logout();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}

// Check authentication state with a 3-second delay
//   Future<void> checkAuthState() async {
//     try {
//       isLoading.value = true;
//       // Ensure splash screen shows for at least 3 seconds
//       await Future.delayed(const Duration(seconds: 3));
//       final user = _authService.currentUser;
//       final currentRoute = Get.currentRoute;
//       Get.log('Current route: $currentRoute');

//       if (user != null) {
//         final isAdmin = await _authService.isAdminCheck(user.uid);
//         Get.log('Admin check for ${user.uid}: $isAdmin');
//         if (isAdmin) {
//           if (currentRoute != AppRoutes.home) {
//             Get.log('Redirecting to home');
//             Get.offAllNamed(AppRoutes.home);
//           }
//         } else {
//           Get.log('User is not admin, signing out');
//           await _authService.signOut();
//           if (currentRoute != AppRoutes.login) {
//             Get.log('Redirecting to login');
//             Get.offAllNamed(AppRoutes.login);
//           }
//         }
//       } else {
//         Get.log('No user logged in');
//         if (currentRoute != AppRoutes.login) {
//           Get.log('Redirecting to login');
//           Get.offAllNamed(AppRoutes.login);
//         }
//       }
//     } catch (e) {
//       Get.log('Error checking auth state: $e');
//       errorMessage.value = 'Failed to check authentication state';
//       if (Get.currentRoute != AppRoutes.login) {
//         Get.offAllNamed(AppRoutes.login);
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Sign in
//   Future<void> signIn(String email, String password) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       await _authService.signIn(email, password);
//       Get.offAllNamed(AppRoutes.home);
//     } catch (e) {
//       Get.log('Sign-in failed: $e');
//       errorMessage.value = e.toString().replaceFirst('Exception: ', '');
//       if (errorMessage.value.contains('PigeonUserDetails')) {
//         errorMessage.value = 'Authentication error, please try again';
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       await _authService.signOut();
//       Get.offAllNamed(AppRoutes.login);
//     } catch (e) {
//       Get.log('Sign-out failed: $e');
//       errorMessage.value = 'Error signing out';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

// import 'package:get/get.dart';
// import 'package:sole_space_admin/app/data/services/auth_service.dart';
// import 'package:sole_space_admin/app/routes/app_routes.dart';

// class AuthController extends GetxController {
//   final AuthService _authService = AuthService();
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   // Check authentication state
//   Future<void> checkAuthState() async {
//     try {
//       isLoading.value = true;
//       final isLoggedIn = await _authService.isLoggedIn();
//       if (isLoggedIn) {
//         Get.offAllNamed(AppRoutes.home);
//       } else {
//         Get.offAllNamed(AppRoutes.login);
//       }
//     } catch (e) {
//       errorMessage.value = 'Error checking authentication state';
//       Get.offAllNamed(AppRoutes.login);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Sign in
//   Future<void> signIn(String email, String password) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       await _authService.signIn(email, password);
//       Get.offAllNamed(AppRoutes.home);
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Sign out
//   Future<void> signOut() async {
//     try {
//       isLoading.value = true;
//       await _authService.signOut();
//       Get.offAllNamed(AppRoutes.login);
//     } catch (e) {
//       errorMessage.value = 'Error signing out';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
