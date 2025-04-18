import 'package:get/get.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/app/ui/pages/splash/splash_page.dart';
import 'package:sole_space_admin/app/ui/pages/login/login_page.dart';
import 'package:sole_space_admin/app/ui/pages/home/home_page.dart';
import 'package:sole_space_admin/bindings/initial_binding.dart';
// import 'package:sole_space_admin/app/ui/pages/dashboard/dashboard_page.dart';
// import 'package:sole_space_admin/app/ui/pages/products/add_product_page.dart';
// import 'package:sole_space_admin/app/ui/pages/products/manage_products_page.dart';
// import 'package:sole_space_admin/app/ui/pages/orders/manage_orders_page.dart';
// import 'package:sole_space_admin/app/ui/pages/users/manage_users_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: InitialBinding(),
    ),
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    // GetPage(name: AppRoutes.dashboard, page: () => const DashboardPage()),
    // GetPage(name: AppRoutes.addProduct, page: () => const AddProductPage()),
    // GetPage(
    //   name: AppRoutes.manageProducts,
    //   page: () => const ManageProductsPage(),
    // ),
    // GetPage(name: AppRoutes.manageOrders, page: () => const ManageOrdersPage()),
    // GetPage(name: AppRoutes.manageUsers, page: () => const ManageUsersPage()),
  ];
}
