import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String title;
  final String location;
  final double price;
  final String description;
  final String imageUrl;
  final Timestamp createdAt;

  ProductModel({
    required this.title,
    required this.location,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  // Factory constructor to create an instance from a Firestore document
  factory ProductModel.fromJson(Map<String, dynamic> data) {
    return ProductModel(
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Method to convert the object to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
