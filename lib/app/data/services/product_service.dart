import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_admin/app/data/models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all products
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection('products')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList(),
        );
  }

  // Fetch brands
  Future<List<Map<String, dynamic>>> fetchBrands() async {
    final snapshot = await _firestore.collection('brands').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fetch categories
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Add product
  Future<void> addProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(product.toJson());
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toJson());
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }
}
