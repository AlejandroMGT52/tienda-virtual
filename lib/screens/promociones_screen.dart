import 'package:flutter/material.dart';
import 'package:tienda_virtual_flutter/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:tienda_virtual_flutter/providers/cart_provider.dart';
import 'package:tienda_virtual_flutter/models/product.dart'; // Importante: Importa Product desde el archivo correcto
import 'package:tienda_virtual_flutter/components/navbar.dart';

class PromocionesScreen extends StatefulWidget {
  const PromocionesScreen({Key? key}) : super(key: key);

  @override
  _PromocionesScreenState createState() => _PromocionesScreenState();
}

class _PromocionesScreenState extends State<PromocionesScreen> {
  String _selectedCategory = 'Todas';
  // Lista de productos con promociones
  final List<Product> _products = [
    Product(
      id: 101,
      title: "Leche Entera - 2x1",
      price: 2.49,
      description: "Llévate 2 unidades de Leche Entera por el precio de 1.",
      category: "Lácteos",
      image: "https://images.unsplash.com/photo-1563636619-e9143da7973b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fG1pbGt8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
      discount: 50,
    ),
    Product(
      id: 102,
      title: "Queso Fresco - 15% Off",
      price: 4.75,
      description: "15% de descuento en Queso Fresco.",
      category: "Lácteos",
      image: "https://www.recetassinlactosa.com//wp-content/uploads/2018/01/Queso-fresco-v.jpg",
      discount: 15,
    ),
    Product(
      id: 111,
      title: "Pan Integral - 3x2",
      price: 3.29,
      description: "Compra 3 panes integrales y paga solo 2.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1509440159596-0249088772ff?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YnJlYWR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
      discount: 33,
    ),
    Product(
      id: 23,
      title: "Tomates Frescos - 25% de descuento",
      price: 2.79,
      description: "25% de descuento en tomates frescos por tiempo limitado",
      category: "Verduras",
      image: "https://images.unsplash.com/photo-1546094096-0df4bcabd1c2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8dG9tYXRvfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
      discount: 25,
    ),
    Product(
      id: 25,
      title: "Arroz Integral - 10% de descuento",
      price: 4.99,
      description: "10% de descuento al comprar arroz integral de 1kg",
      category: "Granos",
      image: "https://images.unsplash.com/photo-1586201375761-83865001e31c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fHJpY2V8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
      discount: 10,
    ),
  ];

  // Agrupa las categorías para la barra de navegación horizontal
  List<String> get _categories => ['Todas', ..._products.map((product) => product.category).toSet().toList()];

  // Filtra los productos según la categoría seleccionada
  List<Product> get _filteredProducts => _selectedCategory == 'Todas'
      ? _products
      : _products.where((product) => product.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;

    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 900) {
      crossAxisCount = 3;
    } else if (screenWidth > 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return Scaffold(
      appBar: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Aprovecha nuestras ofertas especiales! Productos con descuentos por tiempo limitado.',
              style: TextStyle(
                fontSize: 1.1 * 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      selectedColor: AppStyles.primaryColor,
                      labelStyle: TextStyle(
                        color: _selectedCategory == category ? Colors.white : AppStyles.textColor,
                      ),
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 15, // Aumenta el espaciado
                  mainAxisSpacing: 15,
                  childAspectRatio: screenWidth > 600 ? 0.8 : 0.95, // Ajusta el aspect ratio
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return _buildProductCard(product, cartProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir la tarjeta de cada producto
  Widget _buildProductCard(Product product, CartProvider cartProvider) {
    // Calcula el precio con descuento
    double discountedPrice = product.discount != null
        ? product.price - (product.price * product.discount! / 100)
        : product.price;

    return Container(
      decoration: BoxDecoration( // Usamos BoxDecoration directamente en el Container
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Sutil sombra
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centramos los elementos
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: Text('Imagen no disponible')),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 1.0 * 16.0,
                color: AppStyles.textColor,
              ),
              textAlign: TextAlign.center, // Centramos el título
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              product.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 0.9 * 14.0,
              ),
              textAlign: TextAlign.center, // Centramos la descripción
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centramos el precio
              children: [
                if (product.discount != null && product.discount! > 0)
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 0.9 * 14.0,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 8), // Espacio entre precios
                Text(
                  '\$${discountedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 1.1 * 18.0, // Precio más grande
                    color: AppStyles.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                cartProvider.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto agregado al carrito')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.secondaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Más padding
              ),
              child: const Text('Agregar al carrito'), // Cambiamos el texto del botón
            ),
          ],
        ),
      ),
    );
  }
}

