import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
