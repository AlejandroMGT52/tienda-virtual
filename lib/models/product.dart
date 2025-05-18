import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final String title;
  final String category;
  final int? discount; // Make discount nullable

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.title,
    required this.category,
    this.discount, // Make discount optional
  });

  // Factory constructor to create a Product from a Firestore document.
  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      discount: data['discount'] as int?, // Read discount as int?
    );
  }

  // Method to convert a Product object to a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'title': title,
      'category': category,
      'discount': discount, // Include discount in the map
    };
  }

  // Add the copyWith method here:
  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    double? price,
    String? title,
    String? category,
    int? discount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      title: title ?? this.title,
      category: category ?? this.category,
      discount: discount ?? this.discount,
    );
  }
}
