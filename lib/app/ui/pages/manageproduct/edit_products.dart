import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sole_space_admin/app/controllers/product_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_button.dart';
import 'package:sole_space_admin/app/core/widgets/custom_dropdown.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/app/data/models/product_model.dart';
import 'package:sole_space_admin/app/routes/app_routes.dart';
import 'package:sole_space_admin/utils/utils.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';
import 'dart:io';

class EditProductsPage extends StatelessWidget {
  EditProductsPage({super.key});

  final Product product = Get.arguments;
  final _formKey = GlobalKey<FormState>();
  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with product data
    controller.initializeEditControllers(product);

    return DismissibleKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Edit ${product.name}')),
        body: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxWidth =
                    constraints.maxWidth > 600 ? 400 : double.infinity;
                return SizedBox(
                  width: maxWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildBasicInformation(),
                        mediumSpacing,
                        _buildPriceInformation(),
                        mediumSpacing,
                        _buildSizeAndColorInformation(),
                        mediumSpacing,
                        _buildDescriptionField(),
                        mediumSpacing,
                        _buildActionButtons(),
                        mediumSpacing,
                        _buildImageSections(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _informationText('Basic Information'),
        mediumSpacing,
        _buildNameField(),
        mediumSpacing,
        _buildBrandDropDown(),
        mediumSpacing,
        _buildCategoryDropDown(),
      ],
    );
  }

  Widget _buildPriceInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _informationText('Price Information'),
        mediumSpacing,
        _buildPriceField(),
        mediumSpacing,
        _buildDiscountPrice(),
        mediumSpacing,
        _buildStockField(),
      ],
    );
  }

  Widget _buildSizeAndColorInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _informationText('Size and Color Information'),
        mediumSpacing,
        _buildSizeField(),
        // mediumSpacing,
        // _buildColorField(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_buildImageButton(), _buildUpdateButton()],
    );
  }

  Widget _buildImageSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildExistingImages(), mediumSpacing, _buildNewImages()],
    );
  }

  Widget _buildExistingImages() {
    return Obx(
      () =>
          controller.existingImageUrls.isNotEmpty
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Existing Images:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.existingImageUrls.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  controller.existingImageUrls[index],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => controller.removeExistingImage(
                                      controller.existingImageUrls[index],
                                    ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )
              : const Text('No existing images.'),
    );
  }

  Widget _buildNewImages() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Images:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Selected: ${controller.editSelectedImages.length}'),
            ],
          ),
          if (controller.editSelectedImages.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(width: 10),
                scrollDirection: Axis.horizontal,
                itemCount: controller.editSelectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(controller.editSelectedImages[index].path),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed:
                              () => controller.removeNewImage(
                                controller.editSelectedImages[index],
                              ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Align _informationText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  CustomButton _buildUpdateButton() {
    return CustomButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await controller.updateProductWithImages(product);
          Get.offNamed(AppRoutes.manageProducts);
        }
      },
      text: 'Update Product',
      isFullWidth: false,
      isLoading: controller.isLoading.value,
    );
  }

  CustomButton _buildImageButton() {
    return CustomButton(
      onPressed: () async {
        final images = await ImagePicker().pickMultiImage();
        for (var image in images) {
          controller.addNewImage(image);
        }
      },
      text: 'Pick New Images',
      isFullWidth: false,
    );
  }

  CustomTextField _buildStockField() {
    return CustomTextField(
      controller: controller.editStockController,
      label: 'Stock Quantity',
      keyboardType: TextInputType.number,
      validator:
          (value) => ValidationUtils.validateNumber(value, 'stock quantity'),
    );
  }

  CustomTextField _buildPriceField() {
    return CustomTextField(
      controller: controller.editPriceController,
      label: 'Price',
      keyboardType: TextInputType.number,
      validator:
          (value) => ValidationUtils.validateNumber(
            value,
            'price',
            allowDecimal: true,
          ),
    );
  }

  CustomDropdown _buildCategoryDropDown() {
    return CustomDropdown(
      value:
          controller.editSelectedCategory.value.isEmpty
              ? null
              : controller.editSelectedCategory.value,
      hintText: 'Select Category',
      items: controller.categories,
      onChanged: (value) => controller.editSelectedCategory.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'category'),
    );
  }

  CustomDropdown _buildBrandDropDown() {
    return CustomDropdown(
      value:
          controller.editSelectedBrand.value.isEmpty
              ? null
              : controller.editSelectedBrand.value,
      hintText: 'Select Brand',
      items: controller.brands,
      onChanged: (value) => controller.editSelectedBrand.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'brand'),
    );
  }

  CustomTextField _buildDescriptionField() {
    return CustomTextField(
      controller: controller.editDescriptionController,
      label: 'Description',
      maxLines: 3,
      validator:
          (value) => ValidationUtils.validateRequired(value, 'description'),
    );
  }

  CustomTextField _buildNameField() {
    return CustomTextField(
      controller: controller.editNameController,
      label: 'Product Name',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'product name'),
    );
  }

  CustomTextField _buildSizeField() {
    return CustomTextField(
      controller: controller.editSizesController,
      label: 'Sizes (comma-separated, e.g., 7,8,9)',
      validator: (value) => ValidationUtils.validateRequired(value, 'sizes'),
    );
  }

  // CustomTextField _buildColorField() {
  //   return CustomTextField(
  //     controller: controller.editColorsController,
  //     label: 'Colors (comma-separated, e.g., Red,Blue)',
  //     validator: (value) => ValidationUtils.validateRequired(value, 'colors'),
  //   );
  // }

  CustomTextField _buildDiscountPrice() {
    return CustomTextField(
      controller: controller.editDiscountController,
      label: 'Discount Price',
      keyboardType: TextInputType.number,
      validator:
          (value) => ValidationUtils.validateNumber(
            value,
            'Discount Price',
            allowDecimal: true,
          ),
    );
  }
}
