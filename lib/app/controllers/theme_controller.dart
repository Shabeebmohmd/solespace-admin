import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Reactive theme mode
  var themeMode = ThemeMode.dark.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Optionally load saved theme from storage
  //   // Example with GetStorage:
  //   // var savedTheme = GetStorage().read('theme');
  //   // if (savedTheme != null) {
  //   //   themeMode.value = savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark;
  //   // }
  // }

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
    // Optionally save theme preference
    // GetStorage().write('theme', themeMode.value == ThemeMode.light ? 'light' : 'dark');
  }

  bool isDarkMode() => themeMode.value == ThemeMode.dark;
}
