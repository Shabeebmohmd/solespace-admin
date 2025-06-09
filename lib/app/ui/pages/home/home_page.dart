import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/constants/constants.dart';
import 'package:sole_space_admin/app/controllers/auth_controller.dart';
import 'package:sole_space_admin/app/controllers/theme_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_card.dart';
import 'package:sole_space_admin/app/theme/app_color.dart';

class HomePage extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: Obx(
          () =>
              themeController.isDarkMode()
                  ? IconButton(
                    onPressed: () => themeController.toggleTheme(),
                    icon: Icon(Icons.light_mode),
                    color: Theme.of(context).colorScheme.onSurface,
                  )
                  : IconButton(
                    onPressed: () => themeController.toggleTheme(),
                    icon: Icon(Icons.dark_mode),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
        ),
        showBackButton: false,
        title: Text('SoleSpace'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed:
                () => Get.defaultDialog(
                  title: 'Log out',
                  middleText: 'Are you sure you want log out?',
                  textConfirm: 'confirm',
                  buttonColor: AppColors.primary,
                  onConfirm: () => authController.logOut(),
                  textCancel: 'Cancel',
                ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: ListView.separated(
          itemCount: 5,
          separatorBuilder: (context, index) => SizedBox(height: 40),
          padding: const EdgeInsets.all(16),
          itemBuilder: (BuildContext context, int index) {
            return CustomCard(
              onTap: () => Get.toNamed(menuItems[index]['route'] as String),
              gradient: cardGradients[index],
              child: Row(
                children: [
                  Icon(menuItems[index]['icon'] as IconData, size: 60),
                  const SizedBox(width: 12),
                  Text(
                    menuItems[index]['title'] as String,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
