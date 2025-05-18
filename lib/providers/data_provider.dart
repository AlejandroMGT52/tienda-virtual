import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda_virtual_flutter/models/product.dart';
import 'package:tienda_virtual_flutter/models/promotion.dart';

class DataProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Promotion> _promotions = [];
  List<Promotion> get promotions => _promotions;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  DataProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Cargar productos
      final productsSnapshot =
          await FirebaseFirestore.instance.collection('products').get();
      _products = productsSnapshot.docs
          .map((doc) => Product.fromMap(doc.data()!, doc.id))
          .toList();

      // Cargar promociones
      final promotionsSnapshot =
          await FirebaseFirestore.instance.collection('promotions').get();
      _promotions = promotionsSnapshot.docs
          .map((doc) => Promotion.fromMap(doc.data()!, doc.id))
          .toList();
    } catch (e) {
      print('Error al cargar datos: $e');
      _error = 'Error al cargar los datos. Por favor, intenta de nuevo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Promotion? getPromotionById(String id) {
    try {
      return _promotions.firstWhere((promotion) => promotion.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Promotion> getActivePromotionsForProduct(String productId) {
    final now = DateTime.now();
    return _promotions.where((promotion) {
      final appliesToProduct = promotion.productIds?.contains(productId) ?? false;
      final isNotStarted = promotion.startDate != null && promotion.startDate!.isAfter(now);
      final isEnded = promotion.endDate != null && promotion.endDate!.isBefore(now);
      return appliesToProduct && !isNotStarted && !isEnded;
    }).toList();
  }

  double applyDiscount(Product product) {
    if (product.discount != null && product.discount! > 0) {
      return product.price * (1 - product.discount! / 100);
    }
    final activePromotions = getActivePromotionsForProduct(product.id);
    if (activePromotions.isNotEmpty) {
      double maxDiscount = 0;
      for (final promotion in activePromotions) {
        if (promotion.discountPercentage > maxDiscount) {
          maxDiscount = promotion.discountPercentage;
        }
      }
      return product.price * (1 - maxDiscount / 100);
    }
    return product.price;
  }
}