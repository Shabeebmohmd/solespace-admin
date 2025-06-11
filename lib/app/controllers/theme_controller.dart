import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Make themeMode observable
  final _isDarkMode = false.obs;

  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromBox();
  }

  void _loadThemeFromBox() {
    _isDarkMode.value = _box.read(_key) ?? false;
  }

  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _saveThemeToBox(_isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }

  bool isDarkMode() => _isDarkMode.value;
}
