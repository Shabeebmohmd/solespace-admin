import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sole_space_admin/app/data/models/product_model.dart';
import 'package:sole_space_admin/app/data/services/cloudinary_service.dart';
import 'package:sole_space_admin/app/data/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  // Text Controllers for Add Product
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final discountController = TextEditingController();
  final sizesController = TextEditingController();
  final colorsController = TextEditingController();

  // Text Controllers for Edit Product
  final editNameController = TextEditingController();
  final editDescriptionController = TextEditingController();
  final editPriceController = TextEditingController();
  final editStockController = TextEditingController();
  final editDiscountController = TextEditingController();
  final editSizesController = TextEditingController();
  final editColorsController = TextEditingController();

  // Rx Variables
  final selectedBrand = ''.obs;
  final selectedCategory = ''.obs;
  final selectedImages = <XFile>[].obs;
  final editSelectedBrand = ''.obs;
  final editSelectedCategory = ''.obs;
  final editSelectedImages = <XFile>[].obs;
  final existingImageUrls = <String>[].obs;
  final newImageUrls = <String>[].obs;

  // Observable Lists
  var products = <Product>[].obs;
  var brands = <Map<String, dynamic>>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchBrands();
    fetchCategories();
  }

  @override
  void onClose() {
    // Dispose add product controllers
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    discountController.dispose();
    sizesController.dispose();
    colorsController.dispose();

    // Dispose edit product controllers
    editNameController.dispose();
    editDescriptionController.dispose();
    editPriceController.dispose();
    editStockController.dispose();
    editDiscountController.dispose();
    editSizesController.dispose();
    editColorsController.dispose();
    super.onClose();
  }

  // Initialize edit controllers with product data
  void initializeEditControllers(Product product) {
    editNameController.text = product.name;
    editDescriptionController.text = product.description;
    editPriceController.text = product.price.toString();
    editDiscountController.text = product.discountPrice?.toString() ?? '';
    editSizesController.text = product.sizes.join(', ');
    // editColorsController.text = product.colors.join(', ');
    editStockController.text = product.stockQuantity.toString();
    editSelectedBrand.value = product.brandId;
    editSelectedCategory.value = product.categoryId;
    editSelectedImages.clear();
    existingImageUrls.value = List.from(product.imageUrls);
    newImageUrls.clear();
  }

  void fetchProducts() {
    isLoading.value = true;
    _productService.getProducts().listen(
      (productList) {
        products.value = productList;
        isLoading.value = false;
      },
      onError: (e) {
        Get.snackbar('Error', 'Failed to fetch products: $e');
        isLoading.value = false;
      },
    );
  }

  Future<void> fetchBrands() async {
    try {
      final brandList = await _productService.fetchBrands();
      brands.value = brandList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch brands: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      final categoryList = await _productService.fetchCategories();
      categories.value = categoryList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    }
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required String brandId,
    required String categoryId,
    required double price,
    double? discountPrice,
    required int stockQuantity,
    required List<XFile> images,
    List<String>? sizes,
    List<String>? colors,
    required bool isAvailable,
  }) async {
    try {
      isLoading.value = true;
      final imageUrls = await _cloudinaryService.uploadProductsImages(images);

      final product = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        brandId: brandId,
        categoryId: categoryId,
        price: price,
        discountPrice: discountPrice,
        stockQuantity: stockQuantity,
        imageUrls: imageUrls,
        sizes: sizes ?? [],
        // colors: colors ?? [],
        isAvailable: isAvailable,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _productService.addProduct(product);
      Get.snackbar('Success', 'Product added successfully');
      // Clear form fields after successful addition
      clearAddProductForm();
      // Refresh products list after adding
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to clear all form fields for adding a new product
  void clearAddProductForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    stockController.clear();
    discountController.clear();
    sizesController.clear();
    colorsController.clear();
    selectedBrand.value = '';
    selectedCategory.value = '';
    selectedImages.clear();
  }

  Future<void> updateProduct(Product product) async {
    try {
      isLoading.value = true;
      product.updatedAt = DateTime.now();
      await _productService.updateProduct(product);
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) products[index] = product;
      Get.snackbar('Success', 'Product updated successfully');
      // Refresh products list after updating
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      isLoading.value = true;
      await _productService.deleteProduct(productId);
      products.removeWhere((p) => p.id == productId);
      Get.snackbar('Success', 'Product deleted successfully');
      // Refresh products list after deleting
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getBrandName(String brandId) {
    final brand = brands.firstWhere(
      (b) => b['id'] == brandId,
      orElse: () => {'name': 'Unknown'},
    );
    return brand['name'] as String;
  }

  String getCategoryName(String categoryId) {
    final category = categories.firstWhere(
      (c) => c['id'] == categoryId,
      orElse: () => {'name': 'Unknown'},
    );
    return category['name'] as String;
  }

  // Upload images to Cloudinary
  Future<List<String>> uploadProductsImages(List<XFile> images) async {
    return await _cloudinaryService.uploadProductsImages(images);
  }

  // Remove an existing image
  void removeExistingImage(String imageUrl) {
    existingImageUrls.remove(imageUrl);
  }

  // Add a new image
  void addNewImage(XFile image) {
    editSelectedImages.add(image);
  }

  // Remove a new image
  void removeNewImage(XFile image) {
    editSelectedImages.remove(image);
  }

  // Get all images (existing + new)
  List<String> getAllImages() {
    return [...existingImageUrls, ...newImageUrls];
  }

  // Update product with new images
  Future<void> updateProductWithImages(Product product) async {
    try {
      isLoading.value = true;

      // Upload new images if any
      if (editSelectedImages.isNotEmpty) {
        newImageUrls.value = await uploadProductsImages(editSelectedImages);
      }

      // Create updated product with all images
      final updatedProduct = Product(
        id: product.id,
        name: editNameController.text,
        description: editDescriptionController.text,
        brandId: editSelectedBrand.value,
        categoryId: editSelectedCategory.value,
        price: double.parse(editPriceController.text),
        discountPrice:
            editDiscountController.text.isEmpty
                ? null
                : double.parse(editDiscountController.text),
        stockQuantity: int.parse(editStockController.text),
        imageUrls: [...existingImageUrls, ...newImageUrls],
        sizes:
            editSizesController.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
        // colors:
        //     editColorsController.text
        //         .split(',')
        //         .map((e) => e.trim())
        //         .where((e) => e.isNotEmpty)
        //         .toList(),
        isAvailable: product.isAvailable,
        createdAt: product.createdAt,
        updatedAt: DateTime.now(),
      );

      await updateProduct(updatedProduct);
    } finally {
      isLoading.value = false;
    }
  }

  // Method to refresh brands and categories
  Future<void> refreshBrandsAndCategories() async {
    await Future.wait([fetchBrands(), fetchCategories()]);
  }
}
