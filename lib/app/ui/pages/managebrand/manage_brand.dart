import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sole_space_admin/app/controllers/brand_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/app/data/models/brand_model.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';

/// A page that displays and manages all brands in a grid layout
class ManageBrandPage extends StatelessWidget {
  ManageBrandPage({super.key});
  final _brandController = Get.find<BrandController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Brand management')),
        floatingActionButton: _buildAddBrandButton(),
        body: _buildBrandGrid(),
      ),
    );
  }

  Widget _buildAddBrandButton() {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(AppRoutes.addBrand),
      label: Row(children: [Icon(Icons.add), Text('Add new brand')]),
    );
  }

  Widget _buildBrandGrid() {
    return Obx(
      () =>
          _brandController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                padding: const EdgeInsets.all(16),
                itemCount: _brandController.brands.length,
                itemBuilder: (context, index) {
                  final brand = _brandController.brands[index];
                  return BrandGridItem(
                    brand: brand,
                    formKey: _formKey,
                    controller: _brandController,
                  );
                },
              ),
    );
  }
}

/// Widget representing a single brand item in the grid
class BrandGridItem extends StatelessWidget {
  const BrandGridItem({
    super.key,
    required this.brand,
    required this.formKey,
    required this.controller,
  });

  final Brand brand;
  final GlobalKey<FormState> formKey;
  final BrandController controller;

  @override
  Widget build(BuildContext context) {
    if (brand.logoImage == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () => _showBrandOptions(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBrandImage(),
          const SizedBox(height: 8),
          _buildBrandName(),
        ],
      ),
    );
  }

  Widget _buildBrandImage() {
    return Flexible(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(brand.logoImage!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandName() {
    return Text(
      brand.name,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }

  void _showBrandOptions(BuildContext context) {
    Get.defaultDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Edit'),
              onTap: () {
                Get.back();
                _showEditDialog();
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Delete'),
              onTap: () {
                Get.back();
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: brand.name);
    final descriptionController = TextEditingController(
      text: brand.description,
    );
    controller.clearSelectedImage();

    Get.defaultDialog(
      title: 'Edit: ${brand.name}',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      content: BrandEditForm(
        formKey: formKey,
        controller: controller,
        nameController: nameController,
        descriptionController: descriptionController,
        brand: brand,
      ),
      onConfirm: () {
        if (formKey.currentState!.validate()) {
          controller.editBrand(
            brand.id,
            nameController.text,
            descriptionController.text,
            controller.selectedImage.value,
          );
          Get.back();
        }
      },
    );
  }

  void _showDeleteConfirmation() {
    Get.defaultDialog(
      title: 'Delete Brand',
      middleText: 'Are you sure you want to delete this brand?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      onConfirm: () {
        controller.deleteBrand(brand.id);
        Get.back();
      },
    );
  }
}

/// Form widget for editing a brand
class BrandEditForm extends StatelessWidget {
  const BrandEditForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.nameController,
    required this.descriptionController,
    required this.brand,
  });

  final GlobalKey<FormState> formKey;
  final BrandController controller;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final Brand brand;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildImagePicker(),
          const SizedBox(height: 16),
          _buildNameField(),
          const SizedBox(height: 16),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Obx(
      () => GestureDetector(
        onTap: controller.pickImage,
        child: CircleAvatar(radius: 50, backgroundImage: _getBackgroundImage()),
      ),
    );
  }

  ImageProvider _getBackgroundImage() {
    if (controller.selectedImage.value != null) {
      return FileImage(controller.selectedImage.value!);
    }
    if (brand.logoImage != null && brand.logoImage!.isNotEmpty) {
      return NetworkImage(brand.logoImage!);
    }
    return const AssetImage('assets/images/Placeholder.jpeg');
  }

  Widget _buildNameField() {
    return CustomTextField(
      label: 'Brand name',
      controller: nameController,
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Brand name'),
    );
  }

  Widget _buildDescriptionField() {
    return CustomTextField(
      label: 'Description',
      controller: descriptionController,
      maxLines: 3,
      validator:
          (value) => ValidationUtils.validateRequired(value, 'Description'),
    );
  }
}
