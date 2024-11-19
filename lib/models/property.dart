// lib/models/property.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String id;
  final String sellerId;
  final String title;
  final double price;
  final String description;
  final String type;
  final List<String> images;
  final DateTime createdAt;

  Property({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.price,
    required this.description,
    required this.type,
    required this.images,
    required this.createdAt,
  });

  factory Property.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Property(
      id: doc.id,
      sellerId: data['sellerId'],
      title: data['title'],
      price: data['price'].toDouble(),
      description: data['description'],
      type: data['type'],
      images: List<String>.from(data['images']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}