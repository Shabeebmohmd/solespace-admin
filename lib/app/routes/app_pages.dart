import 'package:get/get.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/app/ui/pages/addproduct/add_products.dart';
import 'package:sole_space_admin/app/ui/pages/dashboard/dash_board.dart';
import 'package:sole_space_admin/app/ui/pages/manageorders/manage_orders.dart';
import 'package:sole_space_admin/app/ui/pages/manageproduct/manage_products.dart';
import 'package:sole_space_admin/app/ui/pages/manageuser/manage_user.dart';
import 'package:sole_space_admin/app/ui/pages/splash/splash_page.dart';
import 'package:sole_space_admin/app/ui/pages/login/login_page.dart';
import 'package:sole_space_admin/app/ui/pages/home/home_page.dart';
import 'package:sole_space_admin/bindings/initial_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: InitialBinding(),
    ),
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashBoardPage()),
    GetPage(name: AppRoutes.addProduct, page: () => const AddProductsPage()),
    GetPage(
      name: AppRoutes.manageProducts,
      page: () => const ManageProductsPage(),
    ),
    GetPage(name: AppRoutes.manageOrders, page: () => const ManageOrdersPage()),
    GetPage(name: AppRoutes.manageUsers, page: () => const ManageUserPage()),
  ];
}
