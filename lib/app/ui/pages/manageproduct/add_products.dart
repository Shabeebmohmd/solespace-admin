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
                          _buildNameField(),
                          mediumSpacing,
                          _buildDescriptionField(),
                          mediumSpacing,
                          _buildBrandDropDown(),
                          mediumSpacing,
                          _buildCategoryDropDown(),
                          mediumSpacing,
                          _buildPriceField(),
                          mediumSpacing,
                          _buildStockField(),
                          extraMediumSpacing,
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [_buildImageButton(), _buildAddButton()],
                          ),
                          mediumSpacing,
                          Text('Selected Images: ${selectedImages.length}'),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }

  CustomButton _buildAddButton() {
    return CustomButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await controller.addProduct(
            name: nameController.text,
            description: descriptionController.text,
            brandId: selectedBrand.value,
            categoryId: selectedCategory.value,
            price: double.parse(priceController.text),
            stockQuantity: int.parse(stockController.text),
            images: selectedImages,
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
      value: selectedBrand.value.isEmpty ? null : selectedCategory.value,
      hintText: 'select Category',
      items: controller.categories,
      onChanged: (value) => selectedCategory.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'category'),
    );
  }

  CustomDropdown _buildBrandDropDown() {
    return CustomDropdown(
      value: selectedBrand.value.isEmpty ? null : selectedBrand.value,
      hintText: 'select Brand',
      items: controller.brands,
      onChanged: (value) => selectedBrand.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'brand'),
    );
  }

  CustomTextField _buildDescriptionField() {
    return CustomTextField(
      controller: descriptionController,
      label: 'Description',
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
}
