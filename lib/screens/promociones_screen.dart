import 'package:flutter/material.dart';
import 'package:tienda_virtual_flutter/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:tienda_virtual_flutter/providers/cart_provider.dart';
import 'package:tienda_virtual_flutter/models/product.dart';
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
      id: '1', // Añadir ID
      title: "Paquete de Promocion - 50% Off",
      price: 12.39,
      description: "Leche entera, un paquete de espagueti, un paquete de arroz, un paquete de galletas, un paquete de pan de caja y un paquete de queso fresco.",
      category: "Promociones",
      image:
          "https://www.festiregalos.com.mx/cdn/shop/files/513e776f-e708-45b2-acad-484dbe4a4b8c.jpg?v=1725159774",
      discount: 10, name: '',
    ),
    Product(
      id: '2',// Añadir ID
      title: "Paquete de Promociones - 15% Off",
      price: 15.28,
      description: "Un paquete de pan integral, un paquete de espagueti, un paquete de arroz, un paquete de harina, un paquete de frutas y un paquete de salchichas.",
      category: "Promociones",
      image:
          "https://www.festiregalos.com.mx/cdn/shop/files/fb153e0b-da50-4937-ac67-3a1fb9ff7498.jpg?v=1725159625",
      discount: 10, name: '',
    ),
    Product(
      name: '',
      id: '3',// Añadir ID
      title: "Paquete de Promociones - 33% Off",
      price: 16.30,
      description: "Llevate un paquete de pan de caja, un paquete de verduras, un paquete de machica, un paquete de aceite y un paquete de especias de cocina.",
      category: "Promociones",
      image:
          "https://www.festiregalos.com.mx/cdn/shop/files/513e776f-e708-45b2-acad-484dbe4a4b8c.jpg?v=1725159774",
      discount: 10,
    ),
    Product(
      name: '',
      id: '4',// Añadir ID
      title: "Paquete de Promocion - 25% Off",
      price: 10.50,
      description: "Obten un paquete de fideos, un paquete de carnes de asadero, un paquete de utencilios de limpieza, un paquete de condimentos basicos y un paquete de verduras.",
      category: "Promociones",
      image:
          "https://www.guapaconflores.com/cdn/shop/files/canastas-de-navidad-con-vino-queso-y-frutas.jpg?v=1729883545",
      discount: 10,
    ),
    Product(
      name: '',
      id: '5', // Añadir ID
      title: "Paquete de Promocion - 20% Off",
      price: 14.20,
      description: "Llevate un paquete de galletas, un paquete de leche, un paquete de arroz, un paquete de fideos y un paquete de especias.",
      category: "Promociones",
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJcEdkT7fFvtMJXK3-U3qnmjdgxbg-S62sQQ&s",
      discount: 10,
    ),
    Product(
      name: '',
      id: '6', // Añadir ID
      title: "Paquete de Promocion - 5% Off",
      price: 15.29,
      description: "Llevate un paquete de galletas, un paquete de leche, un paquete de arroz, un paquete de fideos y un paquete de especias.",
      category: "Promociones",
      image:
          "https://www.festiregalos.com.mx/cdn/shop/files/E90608A7-DDEA-4323-A83C-23B601CB63E9.jpg?v=1732684419&width=360",
      discount: 10,
    ),
  ];

  // Agrupa las categorías para la barra de navegación horizontal
  List<String> get _categories =>
      ['Todas', ..._products.map((product) => product.category).toSet().toList()];

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
                        color: _selectedCategory == category
                            ? Colors.white
                            : AppStyles.textColor,
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
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: screenWidth > 600 ? 0.8 : 0.95,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      child:
                          const Center(child: Text('Imagen no disponible')),
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
              textAlign: TextAlign.center,
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
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(width: 8),
                Text(
                  '\$${discountedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 1.1 * 18.0,
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
                  const SnackBar(
                      content: Text('Producto agregado al carrito')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.secondaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Agregar al carrito'),
            ),
          ],
        ),
      ),
    );
  }
}