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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController sizesController = TextEditingController();
  final TextEditingController colorsController = TextEditingController();
  final RxString selectedBrand = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxList<XFile> selectedImages = <XFile>[].obs;

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
                          _informationText('Basic Information'),
                          mediumSpacing,
                          _buildNameField(),
                          mediumSpacing,
                          _buildBrandDropDown(),
                          mediumSpacing,
                          _buildCategoryDropDown(),
                          mediumSpacing,
                          _informationText('Price Information'),
                          mediumSpacing,
                          _buildPriceField(),
                          mediumSpacing,
                          _buildDiscountField(),
                          mediumSpacing,
                          _buildStockField(),
                          mediumSpacing,
                          _informationText('Size and Color Information'),
                          mediumSpacing,
                          _buildSizesField(),
                          mediumSpacing,
                          _buildColorsField(),
                          mediumSpacing,
                          _buildDescriptionField(),
                          extraMediumSpacing,
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [_buildImageButton(), _buildAddButton()],
                          ),
                          mediumSpacing,
                          Text('Selected Images: ${selectedImages.length}'),
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

  Widget _buildExistingImages() {
    return Obx(
      () =>
          selectedImages.isNotEmpty
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
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            // Use File for local images
                            File(selectedImages[index].path),
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

  CustomTextField _buildDiscountField() {
    return CustomTextField(
      label: 'Discounted Price',
      controller: discountController,
      keyboardType: TextInputType.number,
      validator:
          (p0) => ValidationUtils.validateNumber(
            p0,
            'Discounted price',
            allowDecimal: true,
          ),
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
          // Split comma-separated sizes and colors into lists
          List<String> sizes =
              sizesController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
          List<String> colors =
              colorsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

          controller.addProduct(
            name: nameController.text,
            description: descriptionController.text,
            brandId: selectedBrand.value,
            categoryId: selectedCategory.value,
            price: double.parse(priceController.text),
            discountPrice:
                discountController.text.isEmpty
                    ? null
                    : double.parse(discountController.text),
            stockQuantity: int.parse(stockController.text),
            images: selectedImages,
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
        selectedImages.value = images;
      },
      text: 'Pick Image',
      isFullWidth: false,
    );
  }

  CustomTextField _buildStockField() {
    return CustomTextField(
      controller: stockController,
      label: 'Stock Quantity',
      keyboardType: TextInputType.number,
      validator:
          (value) => ValidationUtils.validateNumber(value, 'stock quantity'),
    );
  }

  CustomTextField _buildPriceField() {
    return CustomTextField(
      controller: priceController,
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
      value: selectedCategory.value.isEmpty ? null : selectedCategory.value,
      hintText: 'Select Category',
      items: controller.categories,
      onChanged: (value) => selectedCategory.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'category'),
    );
  }

  CustomDropdown _buildBrandDropDown() {
    return CustomDropdown(
      value: selectedBrand.value.isEmpty ? null : selectedBrand.value,
      hintText: 'Select Brand',
      items: controller.brands,
      onChanged: (value) => selectedBrand.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'brand'),
    );
  }

  CustomTextField _buildDescriptionField() {
    return CustomTextField(
      controller: descriptionController,
      label: 'Description',
      maxLines: 3,
      validator:
          (value) => ValidationUtils.validateRequired(value, 'description'),
    );
  }

  CustomTextField _buildNameField() {
    return CustomTextField(
      controller: nameController,
      label: 'Product Name',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'product name'),
    );
  }

  CustomTextField _buildSizesField() {
    return CustomTextField(
      controller: sizesController,
      label: 'Sizes (comma-separated, e.g., 7,8,9)',
      validator: (value) => ValidationUtils.validateRequired(value, 'sizes'),
    );
  }

  CustomTextField _buildColorsField() {
    return CustomTextField(
      controller: colorsController,
      label: 'Colors (comma-separated, e.g., Red,Blue)',
      validator: (value) => ValidationUtils.validateRequired(value, 'colors'),
    );
  }
}
