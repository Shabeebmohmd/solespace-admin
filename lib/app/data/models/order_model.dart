import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final String? paymentIntentId;
  final String? trackingNumber;
  final String? address;
  final String? addressId;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? fullName;
  final String? phoneNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    this.paymentIntentId,
    this.trackingNumber,
    this.address,
    this.addressId,
    this.city,
    this.state,
    this.postalCode,
    this.fullName,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'total': total,
    'status': status,
    'createdAt': Timestamp.fromDate(createdAt),
    'paymentIntentId': paymentIntentId,
    'trackingNumber': trackingNumber,
    'address': address,
    'addressId': addressId,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
  };

  factory Order.fromJson(Map<String, dynamic> json) {
    // Ensure required fields are present and have valid values
    if (json['id'] == null ||
        json['userId'] == null ||
        json['items'] == null ||
        json['total'] == null ||
        json['status'] == null ||
        json['createdAt'] == null) {
      throw FormatException('Missing required fields in order data');
    }

    return Order(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      items:
          (json['items'] as List)
              .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList(),
      total:
          (json['total'] is num)
              ? (json['total'] as num).toDouble()
              : double.tryParse(json['total'].toString()) ?? 0.0,
      status: json['status'].toString(),
      createdAt:
          json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : json['createdAt'] is DateTime
              ? json['createdAt'] as DateTime
              : DateTime.parse(json['createdAt'].toString()),
      paymentIntentId: json['paymentIntentId']?.toString(),
      trackingNumber: json['trackingNumber']?.toString(),
      address: json['address']?.toString(),
      addressId: json['addressId']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      postalCode: json['postalCode']?.toString(),
      fullName: json['fullName']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
    );
  }
}

class OrderItem {
  final String productId;
  final String name;
  final String size;
  final int quantity;
  final double price;
  final String? imageUrl;
  final DateTime addedAt;

  OrderItem({
    required this.productId,
    required this.name,
    required this.size,
    required this.quantity,
    required this.price,
    required this.addedAt,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'size': size,
    'quantity': quantity,
    'price': price,
    'imageUrl': imageUrl,
    'addedAt': Timestamp.fromDate(addedAt),
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Ensure required fields are present and have valid values
    if (json['productId'] == null ||
        json['name'] == null ||
        json['size'] == null ||
        json['quantity'] == null ||
        json['price'] == null ||
        json['addedAt'] == null) {
      throw FormatException('Missing required fields in order item data');
    }

    return OrderItem(
      productId: json['productId'].toString(),
      name: json['name'].toString(),
      size: json['size'].toString(),
      quantity:
          (json['quantity'] is num)
              ? (json['quantity'] as num).toInt()
              : int.tryParse(json['quantity'].toString()) ?? 0,
      price:
          (json['price'] is num)
              ? (json['price'] as num).toDouble()
              : double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['imageUrl']?.toString(),
      addedAt:
          json['addedAt'] is Timestamp
              ? (json['addedAt'] as Timestamp).toDate()
              : json['addedAt'] is DateTime
              ? json['addedAt'] as DateTime
              : DateTime.parse(json['addedAt'].toString()),
    );
  }
}
