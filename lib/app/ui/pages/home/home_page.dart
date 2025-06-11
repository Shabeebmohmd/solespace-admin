import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/constants/constants.dart';
import 'package:sole_space_admin/app/controllers/auth_controller.dart';
import 'package:sole_space_admin/app/controllers/theme_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_card.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/app/theme/app_color.dart';
import 'package:sole_space_admin/utils/utils.dart';

class HomePage extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: CustomAppBar(showBackButton: false, title: Text('SoleSpace')),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              'SoleSpace',
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap:
                () => Get.defaultDialog(
                  title: 'Log out',
                  middleText: 'Are you sure you want log out?',
                  textConfirm: 'confirm',
                  buttonColor: AppColors.primary,
                  onConfirm: () => authController.logOut(),
                  textCancel: 'Cancel',
                ),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          mediumSpacing,
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            trailing: Obx(
              () => Switch(
                value: themeController.isDarkMode(),
                onChanged: (_) => themeController.toggleTheme(),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms & Conditions'),
            onTap: () => Get.toNamed(AppRoutes.termsAndConditions),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          ),
        ],
      ),
    );
  }
}
