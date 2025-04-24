import 'dart:io';

import 'package:get/get.dart';
import 'package:sole_space_admin/app/data/models/catogory_model.dart';
import 'package:sole_space_admin/app/data/services/category_service.dart';

class CategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  void _loadCategories() {
    _categoryService.getCategories().listen(
      (categoryList) {
        categories.value = categoryList;
      },
      onError: (error) {
        Get.snackbar('Error', 'Failed to load categories');
      },
    );
  }

  Future<void> addCategory(
    String name,
    String? description,
    File? image,
  ) async {
    try {
      isLoading.value = true;
      final category = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        imageUrl: image,
        createdAt: DateTime.now(),
      );
      await _categoryService.addCategory(category);
      Get.snackbar('Success', 'Category added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editCategory(
    String id,
    String name,
    String? description,
    File? image,
  ) async {
    try {
      // isLoading.value = true;
      final category = Category(
        id: id,
        name: name,
        description: description,
        imageUrl: image,
        createdAt: DateTime.now(),
      );
      await _categoryService.updateCategory(category);
      Get.snackbar('Success', 'Updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      isLoading.value = true;
      await _categoryService.deleteCategory(categoryId);
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category');
    } finally {
      isLoading.value = false;
    }
  }
}
