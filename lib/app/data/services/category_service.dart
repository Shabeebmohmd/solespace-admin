import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_admin/app/data/models/catogory_model.dart';

class CategoryService {
  final CollectionReference _categoriesRef = FirebaseFirestore.instance
      .collection('categories');

  // Add new category
  Future<void> addCategory(Category category) async {
    try {
      await _categoriesRef.doc(category.id).set(category.toJson());
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  // Get all categories
  Stream<List<Category>> getCategories() {
    return _categoriesRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => Category.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
        });
  }

  // Update category
  Future<void> updateCategory(Category category) async {
    try {
      await _categoriesRef.doc(category.id).update(category.toJson());
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _categoriesRef.doc(categoryId).delete();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
