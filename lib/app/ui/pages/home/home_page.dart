import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/auth_controller.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sole Space Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:
                () => Get.defaultDialog(
                  title: 'Log out',
                  middleText: 'Are you sure you want log out?',
                  textConfirm: 'confirm',
                  onConfirm: () => authController.logOut(),
                  textCancel: 'Cancel',
                ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag, size: 60, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text(
                    'Sole Space Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.dashboard);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Add Product'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.addProduct);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Manage Products'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.manageProducts);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Manage Orders'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.manageOrders);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.manageUsers);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to Sole Space Admin',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Select an option from the menu to get started',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
