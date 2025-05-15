// lib/models/product.dart

class Product {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  int? discount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.discount,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      price: map['price'] as double,
      description: map['description'] as String,
      category: map['category'] as String,
      image: map['image'] as String,
      discount: map['discount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'discount': discount,
    };
  }
}