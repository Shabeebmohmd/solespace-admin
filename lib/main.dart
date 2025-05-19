import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/theme_controller.dart';
import 'package:sole_space_admin/app/routes/app_pages.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/app/theme/app_theme.dart';
import 'package:sole_space_admin/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    Get.log('Firebase initialized successfully');
  } catch (e) {
    Get.log('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeController = Get.find<ThemeController>();
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      title: 'Sole Space Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
