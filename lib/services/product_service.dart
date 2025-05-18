import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda_virtual_flutter/models/product.dart';

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  // Crear un nuevo producto
  Future<Product?> createProduct(Product product) async {
    try {
      final docRef = await _productsCollection.add(product.toMap());
      final newProduct = product.copyWith(id: docRef.id); // Usamos copyWith si lo tienes en tu clase Product
      return newProduct;
    } catch (e) {
      print('Error creating product: $e');
      return null;
    }
  }

  // Obtener todos los productos
  Stream<List<Product>> getProducts() {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Actualizar un producto
  Future<void> updateProduct(Product product) async {
    try {
      await _productsCollection.doc(product.id).update(product.toMap());
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // Eliminar un producto
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  // Obtener un producto por ID
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _productsCollection.doc(productId).get();
      if (doc.exists) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }
}