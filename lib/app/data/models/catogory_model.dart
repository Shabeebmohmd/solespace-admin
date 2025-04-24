import 'dart:io';

class Category {
  final String id;
  final String name;
  final String? description;
  final File? imageUrl;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl?.path,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['logoImage'] != null ? File(json['logoImage']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
