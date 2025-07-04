import 'package:get/get.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/app/ui/pages/managebrand/add_brands.dart';
import 'package:sole_space_admin/app/ui/pages/managebrand/manage_brand.dart';
import 'package:sole_space_admin/app/ui/pages/manageorders/order_details.dart';
import 'package:sole_space_admin/app/ui/pages/manageproduct/add_products.dart';
import 'package:sole_space_admin/app/ui/pages/dashboard/dash_board.dart';
import 'package:sole_space_admin/app/ui/pages/managecategory/add_category.dart';
import 'package:sole_space_admin/app/ui/pages/managecategory/manage_category.dart';
import 'package:sole_space_admin/app/ui/pages/manageorders/manage_orders.dart';
import 'package:sole_space_admin/app/ui/pages/manageproduct/edit_products.dart';
import 'package:sole_space_admin/app/ui/pages/manageproduct/manage_products.dart';
import 'package:sole_space_admin/app/ui/pages/manageproduct/product_details.dart';
import 'package:sole_space_admin/app/ui/pages/splash/splash_page.dart';
import 'package:sole_space_admin/app/ui/pages/login/login_page.dart';
import 'package:sole_space_admin/app/ui/pages/home/home_page.dart';
import 'package:sole_space_admin/app/ui/pages/legal/privacy_policy_page.dart';
import 'package:sole_space_admin/app/ui/pages/legal/terms_and_conditions_page.dart';
import 'package:sole_space_admin/bindings/initial_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: InitialBinding(),
    ),
    // product&brand management&category
    GetPage(name: AppRoutes.manageBrand, page: () => ManageBrandPage()),
    GetPage(name: AppRoutes.addBrand, page: () => AddBrandsPage()),
    GetPage(name: AppRoutes.manageProducts, page: () => ManageProductsPage()),
    GetPage(name: AppRoutes.addProducts, page: () => AddProductPage()),
    GetPage(name: AppRoutes.editProducts, page: () => EditProductsPage()),
    GetPage(name: AppRoutes.productDetails, page: () => ProductDetailsPage()),
    GetPage(name: AppRoutes.manageCategory, page: () => ManageCategoryPage()),
    GetPage(name: AppRoutes.addCategory, page: () => AddCategoryPage()),

    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.home, page: () => HomePage()),
    GetPage(name: AppRoutes.dashboard, page: () => const DashBoardPage()),
    GetPage(name: AppRoutes.manageOrders, page: () => const ManageOrdersPage()),
    GetPage(name: AppRoutes.orderDetails, page: () => OrderDetailspage()),

    // Legal pages
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyPage(),
    ),
    GetPage(
      name: AppRoutes.termsAndConditions,
      page: () => const TermsAndConditionsPage(),
    ),
  ];
}
