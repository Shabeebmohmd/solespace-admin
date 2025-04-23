import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sole_space_admin/app/data/models/brand_model.dart';

class BrandService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _brandsRef = FirebaseFirestore.instance.collection(
    'brands',
  );

  // Add new brand
  Future<void> addBrand(Brand brand) async {
    try {
      await _brandsRef.doc(brand.id).set(brand.toJson());
    } catch (e) {
      throw Exception('Failed to add brand: $e');
    }
  }

  // Get all brands
  Stream<List<Brand>> getBrands() {
    return _brandsRef.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => Brand.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Update brand
  Future<void> updateBrand(Brand brand) async {
    try {
      await _brandsRef.doc(brand.id).update(brand.toJson());
    } catch (e) {
      throw Exception('Failed to update brand: $e');
    }
  }

  // Delete brand
  Future<void> deleteBrand(String brandId) async {
    try {
      await _brandsRef.doc(brandId).delete();
    } catch (e) {
      throw Exception('Failed to delete brand: $e');
    }
  }
}
