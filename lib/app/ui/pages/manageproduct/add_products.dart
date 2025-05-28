import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sole_space_admin/app/controllers/product_controller.dart';
import 'package:sole_space_admin/app/core/widgets/custom_app_bar.dart';
import 'package:sole_space_admin/app/core/widgets/custom_button.dart';
import 'package:sole_space_admin/app/core/widgets/custom_dropdown.dart';
import 'package:sole_space_admin/app/core/widgets/custom_text_field.dart';
import 'package:sole_space_admin/app/core/widgets/dismissible_keyboard.dart';
import 'package:sole_space_admin/utils/utils.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';

class AddProductPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ProductController controller = Get.find<ProductController>();

  AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DismissibleKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Add Product')),
        body: Obx(
          () =>
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    padding: EdgeInsets.all(16),
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
                          extraMediumSpacing,
                          _buildActionButtons(),
                          mediumSpacing,
                          _buildSelectedImagesCount(),
                          mediumSpacing,
                          _buildExistingImages(),
                        ],
                      ),
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
        _buildDiscountField(),
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
        _buildSizesField(),
        mediumSpacing,
        _buildColorsField(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [_buildImageButton(), _buildAddButton()],
    );
  }

  Widget _buildSelectedImagesCount() {
    return Obx(
      () => Text('Selected Images: ${controller.selectedImages.length}'),
    );
  }

  Widget _buildExistingImages() {
    return Obx(
      () =>
          controller.selectedImages.isNotEmpty
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Images:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.selectedImages.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(controller.selectedImages[index].path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
              : const Text('No images selected.'),
    );
  }

  Align _informationText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  CustomButton _buildAddButton() {
    return CustomButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          List<String> sizes =
              controller.sizesController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
          List<String> colors =
              controller.colorsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

          controller.addProduct(
            name: controller.nameController.text,
            description: controller.descriptionController.text,
            brandId: controller.selectedBrand.value,
            categoryId: controller.selectedCategory.value,
            price: double.parse(controller.priceController.text),
            discountPrice:
                controller.discountController.text.isEmpty
                    ? null
                    : double.parse(controller.discountController.text),
            stockQuantity: int.parse(controller.stockController.text),
            images: controller.selectedImages,
            sizes: sizes,
            colors: colors,
            isAvailable: true,
          );
          Get.back();
        }
      },
      text: 'Add Product',
      isFullWidth: false,
    );
  }

  CustomButton _buildImageButton() {
    return CustomButton(
      onPressed: () async {
        final images = await ImagePicker().pickMultiImage();
        controller.selectedImages.value = images;
      },
      text: 'Pick Image',
      isFullWidth: false,
    );
  }

  CustomTextField _buildStockField() {
    return CustomTextField(
      controller: controller.stockController,
      label: 'Stock Quantity',
      keyboardType: TextInputType.number,
      validator:
          (value) => ValidationUtils.validateNumber(value, 'stock quantity'),
    );
  }

  CustomTextField _buildPriceField() {
    return CustomTextField(
      controller: controller.priceController,
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
          controller.selectedCategory.value.isEmpty
              ? null
              : controller.selectedCategory.value,
      hintText: 'Select Category',
      items: controller.categories,
      onChanged: (value) => controller.selectedCategory.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'category'),
    );
  }

  CustomDropdown _buildBrandDropDown() {
    return CustomDropdown(
      value:
          controller.selectedBrand.value.isEmpty
              ? null
              : controller.selectedBrand.value,
      hintText: 'Select Brand',
      items: controller.brands,
      onChanged: (value) => controller.selectedBrand.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'brand'),
    );
  }

  CustomTextField _buildDescriptionField() {
    return CustomTextField(
      controller: controller.descriptionController,
      label: 'Description',
      maxLines: 3,
      validator:
          (value) => ValidationUtils.validateRequired(value, 'description'),
    );
  }

  CustomTextField _buildNameField() {
    return CustomTextField(
      controller: controller.nameController,
      label: 'Product Name',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'product name'),
    );
  }

  CustomTextField _buildSizesField() {
    return CustomTextField(
      controller: controller.sizesController,
      label: 'Sizes (comma-separated, e.g., 7,8,9)',
      validator: (value) => ValidationUtils.validateRequired(value, 'sizes'),
    );
  }

  CustomTextField _buildColorsField() {
    return CustomTextField(
      controller: controller.colorsController,
      label: 'Colors (comma-separated, e.g., Red,Blue)',
      validator: (value) => ValidationUtils.validateRequired(value, 'colors'),
    );
  }

  CustomTextField _buildDiscountField() {
    return CustomTextField(
      label: 'Discounted Price',
      controller: controller.discountController,
      keyboardType: TextInputType.number,
      validator:
          (p0) => ValidationUtils.validateNumber(
            p0,
            'Discounted price',
            allowDecimal: true,
          ),
    );
  }
}
