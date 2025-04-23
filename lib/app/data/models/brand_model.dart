class Brand {
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final DateTime createdAt;

  Brand({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      logoUrl: json['logoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
