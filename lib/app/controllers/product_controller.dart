import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sole_space_admin/app/data/models/product_model.dart';
import 'package:sole_space_admin/app/data/services/cloudinary_service.dart';
import 'package:sole_space_admin/app/data/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

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
      isLoading.value = true;
      brands.value = await _productService.fetchBrands();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch brands: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      categories.value = await _productService.fetchCategories();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    } finally {
      isLoading.value = false;
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
        colors: colors ?? [],
        isAvailable: isAvailable,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _productService.addProduct(product);
      // products.add(product);
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      isLoading.value = true;
      product.updatedAt = DateTime.now();
      await _productService.updateProduct(product);
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) products[index] = product;
      Get.snackbar('Success', 'Product updated successfully');
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
}

// import 'dart:async';

// import 'package:cloudinary_public/cloudinary_public.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sole_space_admin/app/data/models/product_model.dart';

// class ProductController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final CloudinaryPublic _cloudinary = CloudinaryPublic(
//     'diwbhb6vd',
//     'preset-for-upload',
//   );

//   // Observables for state management
//   var products = <Product>[].obs;
//   var brands = <Map<String, dynamic>>[].obs;
//   var categories = <Map<String, dynamic>>[].obs;
//   var isLoading = false.obs;
//   StreamSubscription<QuerySnapshot>? _productsSubscription;
//   // StreamSubscription<QuerySnapshot>? _brandSubscription;
//   // StreamSubscription<QuerySnapshot>? _categorysSubscription;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//     fetchBrands();
//     fetchCategories();
//     // fetchProducts();
//   }

//   // Listen to products in real-time
//   void listenToProducts() {
//     isLoading.value = true;
//     _firestore
//         .collection('products')
//         .snapshots()
//         .listen(
//           (snapshot) {
//             products.value =
//                 snapshot.docs
//                     .map((doc) => Product.fromJson(doc.data()))
//                     .toList();
//             isLoading.value = false;
//           },
//           onError: (e) {
//             Get.snackbar('Error', 'Failed to fetch products: $e');
//             isLoading.value = false;
//           },
//         );
//   }

//   @override
//   void onClose() {
//     _productsSubscription
//         ?.cancel(); // Stop listening when controller is disposed
//     super.onClose();
//   }

//   // void listenToBrands() {
//   //   _firestore.collection('brands').snapshots().listen((snapshot) {
//   //     brands.value = snapshot.docs.map((doc) => doc.data()).toList();
//   //   }, onError: (e) => Get.snackbar('Error', 'Failed to fetch brands: $e'));
//   // }

//   // void listenToCategories() {
//   //   _firestore.collection('categories').snapshots().listen((snapshot) {
//   //     categories.value = snapshot.docs.map((doc) => doc.data()).toList();
//   //   }, onError: (e) => Get.snackbar('Error', 'Failed to fetch categories: $e'));
//   // }

//   // Fetch brands for dropdown
//   Future<void> fetchBrands() async {
//     isLoading.value = true;
//     final snapshot = await _firestore.collection('brands').get();
//     brands.value = snapshot.docs.map((doc) => doc.data()).toList();
//     isLoading.value = false;
//   }

//   // Fetch categories for dropdown
//   Future<void> fetchCategories() async {
//     isLoading.value = true;
//     final snapshot = await _firestore.collection('categories').get();
//     categories.value = snapshot.docs.map((doc) => doc.data()).toList();
//     isLoading.value = false;
//   }

//   // Fetch all products
//   Future<void> fetchProducts() async {
//     isLoading.value = true;
//     final snapshot = await _firestore.collection('products').get();
//     products.value =
//         snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
//     isLoading.value = false;
//   }

//   // Upload images to Cloudinary
//   Future<List<String>> uploadImages(List<XFile> images) async {
//     List<String> imageUrls = [];
//     for (var image in images) {
//       final response = await _cloudinary.uploadFile(
//         CloudinaryFile.fromFile(
//           image.path,
//           resourceType: CloudinaryResourceType.Image,
//         ),
//       );
//       imageUrls.add(response.secureUrl);
//     }
//     return imageUrls;
//   }

//   // Create product
//   Future<void> addProduct({
//     required String name,
//     required String description,
//     required String brandId,
//     required String categoryId,
//     required double price,
//     double? discountPrice,
//     required int stockQuantity,
//     required List<XFile> images,
//     List<String>? sizes,
//     List<String>? colors,
//     required bool isAvailable,
//   }) async {
//     try {
//       isLoading.value = true;
//       // Upload images to Cloudinary
//       final imageUrls = await uploadImages(images);

//       // Create product instance
//       final product = Product(
//         id: _firestore.collection('products').doc().id,
//         name: name,
//         description: description,
//         brandId: brandId,
//         categoryId: categoryId,
//         price: price,
//         discountPrice: discountPrice,
//         stockQuantity: stockQuantity,
//         imageUrls: imageUrls,
//         sizes: sizes,
//         colors: colors,
//         isAvailable: isAvailable,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );

//       // Save to Firebase
//       await _firestore
//           .collection('products')
//           .doc(product.id)
//           .set(product.toJson());

//       // Update local state
//       products.add(product);
//       Get.snackbar('Success', 'Product added successfully');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to add product: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Update product
//   Future<void> updateProduct(Product product) async {
//     try {
//       isLoading.value = true;
//       product.updatedAt = DateTime.now();
//       await _firestore
//           .collection('products')
//           .doc(product.id)
//           .update(product.toJson());
//       final index = products.indexWhere((p) => p.id == product.id);
//       if (index != -1) products[index] = product;
//       Get.snackbar('Success', 'Product updated successfully');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update product: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Delete product
//   Future<void> deleteProduct(String productId) async {
//     try {
//       isLoading.value = true;
//       await _firestore.collection('products').doc(productId).delete();
//       products.removeWhere((p) => p.id == productId);
//       Get.snackbar('Success', 'Product deleted successfully');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to delete product: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Get brand name by brandId
//   String getBrandName(String brandId) {
//     final brand = brands.firstWhere(
//       (b) => b['id'] == brandId,
//       orElse: () => {'name': 'Unknown'},
//     );
//     return brand['name'] as String;
//   }

//   // Get category name by categoryId
//   String getCategoryName(String categoryId) {
//     final category = categories.firstWhere(
//       (c) => c['id'] == categoryId,
//       orElse: () => {'name': 'Unknown'},
//     );
//     return category['name'] as String;
//   }
// }
