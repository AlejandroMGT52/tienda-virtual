import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:tienda_virtual_flutter/models/cart_item.dart'; // Importa la definición CORRECTA de CartItem
import 'package:tienda_virtual_flutter/models/product.dart';
import 'package:collection/collection.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Constructor: Carga el carrito desde SharedPreferences al iniciar
  CartProvider() {
    _loadCartFromPrefs();
  }

  // Carga el carrito desde SharedPreferences
  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    if (cartJson != null) {
      try {
        final cartData = jsonDecode(cartJson) as List;
        _cartItems.clear();
        _cartItems.addAll(cartData.map((item) {
          final productMap = item['product'] as Map<String, dynamic>;
          // Asegúrate de pasar el ID del producto al constructor de Product
          return CartItem(
            product: Product.fromMap(productMap, productMap['id'] ?? ''), // Pass the id
            quantity: item['quantity'] as int,
          );
        }));
        notifyListeners();
      } catch (e) {
        // Manejar error de deserialización.  Esto es CRUCIAL.
        print('Error decoding cart JSON: $e');
        _cartItems.clear(); // Clear the cart to avoid corrupted state.
        notifyListeners();
        await prefs.remove('cart'); //remove the invalid cart
      }
    }
  }

  // Guarda el carrito en SharedPreferences
  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // Usa el método toJson() de CartItem y toMap() de Product
    final cartJson = jsonEncode(_cartItems.map((item) => item.toJson()).toList());
    await prefs.setString('cart', cartJson);
  }

  void addToCart(Product product) {
    final existingItem =
        _cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    final existingItem =
        _cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    if (existingItem != null) {
      if (existingItem.quantity > 1) {
        existingItem.quantity--;
      } else {
        _cartItems.removeWhere((item) => item.product.id == product.id);
      }
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void deleteFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    _saveCartToPrefs();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _saveCartToPrefs();
    notifyListeners();
  }

  double getCartTotal() {
    return _cartItems.fold(
        0, (total, item) => total + (item.product.price * item.quantity));
  }
}