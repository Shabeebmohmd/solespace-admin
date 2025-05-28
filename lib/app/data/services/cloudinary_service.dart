import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'diwbhb6vd',
    'preset-for-upload',
    cache: false,
  );

  Future<String> uploadBrandImage(File? image) async {
    if (image == null) throw Exception('No image selected');
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path, folder: 'brands'),
      );
      return response.secureUrl; // Return the uploaded image URL
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<List<String>> uploadProductsImages(List<XFile> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: 'products',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      imageUrls.add(response.secureUrl);
    }
    return imageUrls;
  }
}
