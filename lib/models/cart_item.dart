import 'package:tienda_virtual_flutter/models/product.dart';

class CartItem {
  Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product'] as Map<String, dynamic>, map['productId']), // Pass productId
      quantity: map['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toMap(), // Use toMap instead of toJson
      'quantity': quantity,
    };
  }
}