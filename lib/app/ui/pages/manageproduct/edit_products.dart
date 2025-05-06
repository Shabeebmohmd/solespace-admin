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
import 'package:sole_space_admin/app/data/services/cloudinary_service.dart';
import 'package:sole_space_admin/utils/utils.dart';
import 'package:sole_space_admin/utils/validate_utils.dart';

class EditProductsPage extends StatelessWidget {
  EditProductsPage({super.key});

  final Product product = Get.arguments; // Product passed as argument
  final _formKey = GlobalKey<FormState>();

  // Controllers and observables
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _dicountController;
  late final TextEditingController _sizeController;
  late final TextEditingController _colorController;
  final RxString selectedBrand = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final ProductController controller = Get.find<ProductController>();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with product data
    _nameController = TextEditingController(text: product.name);
    _descriptionController = TextEditingController(text: product.description);
    _priceController = TextEditingController(text: product.price.toString());
    _dicountController = TextEditingController(
      text: product.discountPrice.toString(),
    );
    _sizeController = TextEditingController(text: product.sizes.join(', '));
    _colorController = TextEditingController(text: product.colors.join(', '));
    _stockController = TextEditingController(
      text: product.stockQuantity.toString(),
    );
    selectedBrand.value = product.brandId;
    selectedCategory.value = product.categoryId;
    // Note: Existing images are handled as URLs, new images as XFile
    // selectedImages will be populated only for new uploads

    return DismissibleKeyboard(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Edit ${product.name}')),
        body: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildNameField(),
                  mediumSpacing,
                  _buildBrandDropDown(),
                  mediumSpacing,
                  _buildCategoryDropDown(),
                  mediumSpacing,
                  _buildPriceField(),
                  mediumSpacing,
                  CustomTextField(
                    controller: _dicountController,
                    label: 'Discount Price',
                    keyboardType: TextInputType.number,
                    validator:
                        (value) => ValidationUtils.validateNumber(
                          value,
                          'Discount Price',
                          allowDecimal: true,
                        ),
                  ),
                  mediumSpacing,
                  _buildSizeField(),
                  mediumSpacing,
                  _buildColorField(),

                  mediumSpacing,
                  _buildStockField(),
                  mediumSpacing,
                  _buildDescriptionField(),
                  // _buildExistingImages(), // Display existing images
                  mediumSpacing,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [_buildImageButton(), _buildUpdateButton()],
                  ),
                  mediumSpacing,
                  Text('New Images Selected: ${selectedImages.length}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomTextField _buildColorField() {
    return CustomTextField(
      controller: _colorController,
      label: 'Colors (comma-separated, e.g., Red,Blue)',
      validator: (value) => ValidationUtils.validateRequired(value, 'colors'),
    );
  }

  CustomTextField _buildSizeField() {
    return CustomTextField(
      controller: _sizeController,
      label: 'Sizes (comma-separated, e.g., 7,8,9)',
      validator: (value) => ValidationUtils.validateRequired(value, 'sizes'),
    );
  }

  // Display existing Cloudinary images
  Widget _buildExistingImages() {
    return product.imageUrls.isNotEmpty
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Existing Images:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product.imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.network(
                      product.imageUrls[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.broken_image),
                    ),
                  );
                },
              ),
            ),
          ],
        )
        : const Text('No existing images.');
  }

  // Update button to save changes
  CustomButton _buildUpdateButton() {
    return CustomButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // Upload new images to Cloudinary, if any
          List<String> newImageUrls = product.imageUrls;
          if (selectedImages.isNotEmpty) {
            newImageUrls = await _cloudinaryService.uploadProductsImages(
              selectedImages,
            );
            newImageUrls.addAll(product.imageUrls); // Keep existing images
          }

          // Create updated product
          final updatedProduct = Product(
            id: product.id,
            name: _nameController.text,
            description: _descriptionController.text,
            brandId: selectedBrand.value,
            categoryId: selectedCategory.value,
            price: double.parse(_priceController.text),
            discountPrice: product.discountPrice,
            stockQuantity: int.parse(_stockController.text),
            imageUrls: newImageUrls,
            sizes: product.sizes,
            colors: product.colors,
            isAvailable: product.isAvailable,
            createdAt: product.createdAt,
            updatedAt: DateTime.now(),
          );

          // Update in Firebase
          await controller.updateProduct(updatedProduct);
          // Navigate back after update
          Get.back();
        }
      },
      text: 'Update Product',
      isFullWidth: false,
    );
  }

  // Image picker button
  CustomButton _buildImageButton() {
    return CustomButton(
      onPressed: () async {
        final images = await ImagePicker().pickMultiImage();
        selectedImages.value = images;
      },
      text: 'Pick New Images',
      isFullWidth: false,
    );
  }

  // Stock quantity field
  CustomTextField _buildStockField() {
    return CustomTextField(
      controller: _stockController,
      label: 'Stock Quantity',
      keyboardType: TextInputType.number,
      validator:
          (value) => ValidationUtils.validateNumber(value, 'stock quantity'),
    );
  }

  // Price field
  CustomTextField _buildPriceField() {
    return CustomTextField(
      controller: _priceController,
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

  // Category dropdown
  CustomDropdown _buildCategoryDropDown() {
    return CustomDropdown(
      value: selectedCategory.value.isEmpty ? null : selectedCategory.value,
      hintText: 'Select Category',
      items: controller.categories,
      onChanged: (value) => selectedCategory.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'category'),
    );
  }

  // Brand dropdown
  CustomDropdown _buildBrandDropDown() {
    return CustomDropdown(
      value: selectedBrand.value.isEmpty ? null : selectedBrand.value,
      hintText: 'Select Brand',
      items: controller.brands,
      onChanged: (value) => selectedBrand.value = value!,
      validator: (value) => ValidationUtils.validateDropdown(value, 'brand'),
    );
  }

  // Description field
  CustomTextField _buildDescriptionField() {
    return CustomTextField(
      controller: _descriptionController,
      label: 'Description',
      maxLines: 3,
      validator:
          (value) => ValidationUtils.validateRequired(value, 'description'),
    );
  }

  // Name field
  CustomTextField _buildNameField() {
    return CustomTextField(
      controller: _nameController,
      label: 'Product Name',
      validator:
          (value) => ValidationUtils.validateRequired(value, 'product name'),
    );
  }
}
