class Brand {
  final String id;
  final String name;
  final String? description;
  final String? logoImage; // Changed from String? to File?
  final DateTime createdAt;

  Brand({
    required this.id,
    required this.name,
    this.description,
    this.logoImage,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoImage': logoImage, // Store the file path
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logoImage: json['logoImage'], // Load the file from path
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
