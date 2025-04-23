import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/auth_controller.dart';
import 'package:sole_space_admin/app/controllers/brand_controller.dart';
import 'package:sole_space_admin/app/controllers/category_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(BrandController());
    Get.put(CategoryController());
  }
}
