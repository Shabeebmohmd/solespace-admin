import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/auth_controller.dart';
import 'package:sole_space_admin/app/controllers/brand_controller.dart';
import 'package:sole_space_admin/app/controllers/category_controller.dart';
import 'package:sole_space_admin/app/controllers/dashboard_controller.dart';
import 'package:sole_space_admin/app/controllers/order_controller.dart';
import 'package:sole_space_admin/app/controllers/product_controller.dart';
import 'package:sole_space_admin/app/controllers/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(AuthController());
    Get.put(BrandController());
    Get.put(CategoryController());
    Get.put(ProductController());
    Get.put(OrderController());
    Get.put(DashboardController());
  }
}
