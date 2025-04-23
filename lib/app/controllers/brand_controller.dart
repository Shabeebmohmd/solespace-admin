import 'package:get/get.dart';
import 'package:sole_space_admin/app/data/models/brand_model.dart';
import 'package:sole_space_admin/app/data/services/brand_service.dart';

class BrandController extends GetxController {
  final BrandService _brandService = BrandService();
  final RxList<Brand> brands = <Brand>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBrands();
  }

  void _loadBrands() {
    _brandService.getBrands().listen(
      (brandList) {
        brands.value = brandList;
      },
      onError: (error) {
        Get.snackbar('Error', 'Failed to load brands');
      },
    );
  }

  Future<void> addBrand(
    String name,
    String? description,
    String? logoUrl,
  ) async {
    try {
      isLoading.value = true;
      final brand = Brand(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        logoUrl: logoUrl,
        createdAt: DateTime.now(),
      );
      await _brandService.addBrand(brand);
      Get.snackbar('Success', 'Brand added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add brand');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editBrand(
    String id,
    String name,
    String? description,
    String? logourl,
  ) async {
    try {
      // isLoading.value = true;
      final brand = Brand(
        id: id,
        name: name,
        description: description,
        logoUrl: logourl,
        createdAt: DateTime.now(),
      );
      await _brandService.updateBrand(brand);
      Get.snackbar('Success', 'Updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update brand');
    }
  }

  Future<void> deleteBrand(String brandId) async {
    try {
      isLoading.value = true;
      await _brandService.deleteBrand(brandId);
      Get.snackbar('Success', 'Brand deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete brand');
    } finally {
      isLoading.value = false;
    }
  }
}
