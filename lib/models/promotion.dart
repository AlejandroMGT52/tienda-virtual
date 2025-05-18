import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  final String id;
  final String title;
  final String description;
  final double discountPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? productIds;

  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.discountPercentage,
    this.startDate,
    this.endDate,
    this.productIds,
  });

  factory Promotion.fromMap(Map<String, dynamic> data, String documentId) {
    return Promotion(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      discountPercentage: (data['discountPercentage'] ?? 0.0).toDouble(),
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      productIds: (data['productIds'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'discountPercentage': discountPercentage,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'productIds': productIds,
    };
  }

  Promotion copyWith({
    String? id,
    String? title,
    String? description,
    double? discountPercentage,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? productIds,
  }) {
    return Promotion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      productIds: productIds ?? this.productIds,
    );
  }
}