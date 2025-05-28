import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sole_space_admin/app/data/models/brand_model.dart';
import 'package:sole_space_admin/app/data/services/brand_service.dart';
import 'package:sole_space_admin/app/data/services/cloudinary_service.dart';

class BrandController extends GetxController {
  final BrandService _brandService = BrandService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final RxList<Brand> brands = <Brand>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Text controllers for brand form
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadBrands();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
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

  Future<void> addBrand(String name, String? description, File? logo) async {
    try {
      isLoading.value = true;

      // Upload the image to Cloudinary
      String? logoUrl;
      if (logo != null) {
        logoUrl = await _cloudinaryService.uploadBrandImage(logo);
      }

      // Create a new brand object
      final brand = Brand(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        logoImage: logoUrl, // Store the Cloudinary URL
        createdAt: DateTime.now(),
      );

      // Save the brand to the database
      await _brandService.addBrand(brand);

      Get.snackbar('Success', 'Brand added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add brand: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editBrand(
    String id,
    String name,
    String? description,
    File? logo,
  ) async {
    try {
      isLoading.value = true;

      // Upload the image to Cloudinary if a new image is selected
      String? logoUrl;
      if (logo != null) {
        logoUrl = await _cloudinaryService.uploadBrandImage(logo);
      }

      // Update the brand object
      final brand = Brand(
        id: id,
        name: name,
        description: description,
        logoImage:
            logoUrl ??
            brands
                .firstWhere((b) => b.id == id)
                .logoImage, // Keep the old image if no new image is uploaded
        createdAt: DateTime.now(),
      );

      // Update the brand in the database
      await _brandService.updateBrand(brand);
      _brandService.getBrands();
      Get.snackbar('Success', 'Brand updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update brand: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
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

  void clearSelectedImage() {
    selectedImage.value = null;
  }
}
