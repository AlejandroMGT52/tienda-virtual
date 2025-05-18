import 'package:flutter/material.dart';
import 'package:tienda_virtual_flutter/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:tienda_virtual_flutter/providers/cart_provider.dart';
import 'package:tienda_virtual_flutter/models/product.dart';
import 'package:tienda_virtual_flutter/components/navbar.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key, required String category}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'Todos';
  // Lista de productos movida a un provider o a un archivo de datos separado
  final List<Product> _products = [
    Product(
      id: '1',
      name: "Leche Entera",
      title: "Leche Entera",
      price: 2.49,
      description: "Leche entera pasteurizada, rica en calcio y vitamina D.",
      category: "Lácteos",
      image:
          "https://images.unsplash.com/photo-1563636619-e9143da7973b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fG1pbGt8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: '2',
      name: "Queso Fresco",
      title: "Queso Fresco",
      price: 4.75,
      description: "Queso fresco y suave, ideal para ensaladas y aperitivos.",
      category: "Lácteos",
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJpv0zz21a5fBelQj_kd23HJ4L7uNsGSiiu2WJPVoeE4Nw87sINoxVI7wWXFieD32FuUk&usqp=CAU",
    ),
    Product(
      id: '3',
      name: "Yogurt Natural",
      title: "Yogurt Natural",
      price: 1.99,
      description: "Yogurt natural sin azúcar, perfecto para un desayuno saludable.",
      category: "Lácteos",
      image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgh316G6N7Q41HSUE2PbLN15SYDJx7YDJdyw&s",
    ),
    // ... (resto de tus productos)
    Product(
      id: '4',
      name: "Espagueti",
      title: "Espagueti",
      price: 2.99,
      description: "Espagueti de trigo duro, perfecto para tus salsas favoritas.",
      category: "Pastas",
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSs4hMyiYa_9uVr5tdqgwjUZxmRN_-W8w6oPw&s",
    ),
    Product(
      id: '5',
      name: "Pan Integral",
      title: "Pan Integral",
      price: 3.98,
      description: "Pan integral con semillas, rico en fibra y nutrientes.",
      category: "Panaderia",
      image:
          "https://www.recetasnestle.cl/sites/default/files/styles/recipe_detail_desktop_new/public/srh_recipes/20ef18804a6c56cc96f2a1c4f8ba749e.jpg?itok=fGlbSBvA",
    ),
    Product(
      id: '6',
      name: "Sandia",
      title: "Sandia",
      price: 4.32,
      description: "Fruta refrescante y dulce, ideal para el verano.",
      category: "Frutas",
      image:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbvYP24zAkICOtt1MdSMe_uEtxheQyYCF2ww&s",
    ),
  ];

  // Las categorías deben ser calculadas, no hardcodeadas
  List<String> get _categories =>
      ['Todos', ..._products.map((product) => product.category).toSet().toList()];

  // Productos filtrados
  List<Product> get _filteredProducts => _selectedCategory == 'Todos'
      ? _products
      : _products.where((product) => product.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2; // Valor por defecto

    // Ajuste de columnas basado en el ancho de la pantalla
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
      appBar: const NavBar(), // Usa tu componente de barra de navegación
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encuentra los mejores productos frescos para tu hogar. Calidad garantizada y precios justos.',
              style: TextStyle(
                fontSize: 16.0, // Usa el tamaño directamente
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Barra de categorías
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
                        if (selected) {
                          // Solo llama a setState si es seleccionado
                          setState(() {
                            _selectedCategory = category;
                          });
                        }
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
            // Grid de productos
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      screenWidth > 600 ? 0.65 : 0.85, // Ajuste para tablets
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts.elementAt(index);
                  return _buildProductCard(
                      product, cartProvider, context); // Pasar context
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir la tarjeta de producto
  Widget _buildProductCard(
      Product product, CartProvider cartProvider, BuildContext context) {
    // Recibe context
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                            child: Text('Imagen no disponible')),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0, // Usa el tamaño directamente
                  color: AppStyles.textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.0, // Usa el tamaño directamente
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0, // Usa el tamaño directamente
                      color: AppStyles.primaryColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      cartProvider.addToCart(product);
                      // Usa el context recibido
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Producto agregado al carrito')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.secondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 14.0), // Usa el tamaño directamente
                    ),
                    child: const Text('Agregar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
