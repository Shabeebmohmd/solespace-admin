import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  // Future<dynamic> uploadImage(File? logo) async {
  //   final url = Uri.parse('https://api.cloudinary.com/v1_1/diwbhb6vd/upload');
  //   final request =
  //       http.MultipartRequest('POST', url)
  //         ..fields['upload_preset'] = 'preset-for-upload'
  //         ..files.add(await http.MultipartFile.fromPath('file', logo!.path));
  //   final response = await request.send();
  //   if (response.statusCode == 200) {
  //     final responseData = await response.stream.toBytes();
  //     final responseString = String.fromCharCodes(responseData);
  //     final jsonMap = jsonDecode(responseString);
  //     final logoUrl = jsonMap['url'];
  //     return logoUrl;
  //   }
  // }
  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'diwbhb6vd',
    'preset-for-upload',
    cache: false,
  );

  Future<String> uploadImage(File? image) async {
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
}
