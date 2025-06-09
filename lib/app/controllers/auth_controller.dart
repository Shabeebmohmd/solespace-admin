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

