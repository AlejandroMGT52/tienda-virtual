import 'package:flutter/material.dart';
import 'package:tienda_virtual_flutter/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:tienda_virtual_flutter/providers/cart_provider.dart';
import 'package:tienda_virtual_flutter/models/product.dart';
import 'package:tienda_virtual_flutter/components/navbar.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'Todos';
  final List<Product> _products = [
    Product(
      id: 1,
      title: "Leche Entera",
      price: 2.49,
      description: "Leche entera pasteurizada, rica en calcio y vitamina D.",
      category: "Lácteos",
      image: "https://images.unsplash.com/photo-1563636619-e9143da7973b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fG1pbGt8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 2,
      title: "Queso Fresco",
      price: 4.75,
      description: "Queso fresco y suave, ideal para ensaladas y aperitivos.",
      category: "Lácteos",
      image: "https://www.recetassinlactosa.com//wp-content/uploads/2018/01/Queso-fresco-v.jpg",
    ),
    Product(
      id: 3,
      title: "Yogurt Natural",
      price: 1.99,
      description: "Yogurt natural sin azúcar, perfecto para un desayuno saludable.",
      category: "Lácteos",
      image: "https://osojimix.com/wp-content/uploads/2021/04/YOGURT-NATURAL.jpg",
    ),
    Product(
      id: 4,
      title: "Mantequilla",
      price: 3.50,
      description: "Mantequilla pura de leche de vaca, ideal para cocinar y untar.",
      category: "Lácteos",
      image: "https://nutrimill.com/cdn/shop/articles/Butter_vs_Margarine_Everything_You_Need_To_Know_for_Baking.png?v=1685546304&width=1920",
    ),
    Product(
      id: 5,
      title: "Crema de Leche",
      price: 2.80,
      description: "Crema de leche fresca, perfecta para postres y salsas.",
      category: "Lácteos",
      image: "https://www.arete.com.py/userfiles/images/productos/7840042003033.jpg",
    ),
    Product(
      id: 6,
      title: "Leche Deslactosada",
      price: 2.79,
      description: "Leche deslactosada, fácil de digerir y con el mismo sabor.",
      category: "Lácteos",
      image: "https://chedrauimx.vtexassets.com/arquivos/ids/46450892-800-auto?v=638792545239430000&width=800&height=auto&aspect=true",
    ),
    Product(
      id: 7,
      title: "Queso Mozzarella",
      price: 5.20,
      description: "Queso mozzarella fresco, ideal para pizzas y ensaladas caprese.",
      category: "Lácteos",
      image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOr6VeRUblhNaRM0rpe8Pxant6nc2l1IE-dQ&s",
    ),
    Product(
      id: 8,
      title: "Leche de Almendras",
      price: 3.99,
      description: "Bebida de almendras sin azúcar, una alternativa vegetal a la leche.",
      category: "Lácteos",
      image: "https://www.elespectador.com/resizer/v2/Q3HKYBG255AHLCSYAZ6X4ANKSU.jpg?auth=a431dbff7eb69e04a01ab8288a08977d38312713a6061ac5f05b5b8109d35173&width=920&height=613&smart=true&quality=60",
    ),
    Product(
      id: 9,
      title: "Kéfir Natural",
      price: 3.10,
      description: "Kéfir natural, una bebida láctea fermentada rica en probióticos.",
      category: "Lácteos",
      image: "https://www.moncloa.com/wp-content/uploads/2024/06/kefir-de-mercadona.webp",
    ),
    Product(
      id: 10,
      title: "Helado de Vainilla",
      price: 4.50,
      description: "Delicioso helado cremoso de vainilla.",
      category: "Lácteos",
      image: "https://colanta.com/sabe-mas/wp-content/uploads/Vainilla-chips-1L-1.png",
    ),
    Product(
      id: 11,
      title: "Pan Integral",
      price: 3.29,
      description: "Pan integral de grano completo, ideal para tostadas y sándwiches.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1509440159596-0249088772ff?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YnJlYWR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 12,
      title: "Croissant",
      price: 2.15,
      description: "Crujiente croissant recién horneado, perfecto para acompañar tu café.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1555274175-9845e3a194f8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y3JvaXNzYW50fGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 13,
      title: "Baguette",
      price: 2.50,
      description: "Baguette francesa tradicional, ideal para bocadillos.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1599597247278-47a952a693b8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJhZ3VldHRlfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 14,
      title: "Pan de Centeno",
      price: 3.80,
      description: "Pan de centeno con sabor intenso y textura densa.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1604119304143-4295649a32fa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHJ5ZSUyMGJyZWFkfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 15,
      title: "Pan de Masa Madre",
      price: 4.20,
      description: "Pan de masa madre con corteza crujiente y miga aireada.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1584677388788-2f6a51788eba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fHNvdXJkb3VnaCUyMGJyZWFkfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 16,
      title: "Rollos de Canela",
      price: 3.50,
      description: "Rollos de canela dulces y pegajosos, perfectos para el desayuno.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1603064752734-562782899c47?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGNpbm5hbW9uJTIwcm9sbHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 17,
      title: "Donas Glaseadas",
      price: 2.00,
      description: "Donas suaves y esponjosas con un glaseado dulce.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1558024345-6c157a79a079?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGRvbnV0c3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 18,
      title: "Muffins de Arándanos",
      price: 2.75,
      description: "Muffins caseros con arándanos frescos y jugosos.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1553531384-1a99c44478c5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fG11ZmZpbnN8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 19,
      title: "Galletas de Avena",
      price: 1.50,
      description: "Galletas de avena saludables y deliciosas.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1562621429-538991a1051b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fG9hdCUyMGNvb2tpZXN8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 20,
      title: "Pretzel Salado",
      price: 1.80,
      description: "Pretzel horneado con sal gruesa, perfecto para un snack.",
      category: "Panadería",
      image: "https://images.unsplash.com/photo-1583570744975-5c814ba89fca?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8cHJldHplbHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 21,
      title: "Manzanas Rojas",
      price: 1.99,
      description: "Manzanas rojas dulces y crujientes, una fuente excelente de fibra.",
      category: "Frutas",
      image: "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8YXBwbGV8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 22,
      title: "Plátanos",
      price: 1.25,
      description: "Plátanos maduros, ricos en potasio y energía natural.",
      category: "Frutas",
      image: "https://images.unsplash.com/photo-1589307885939-9b546174d5c5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHBhc3RhfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 23,
      title: "Tomates Frescos",
      price: 2.79,
      description: "Tomates rojos y jugosos, perfectos para ensaladas y guisos.",
      category: "Verduras",
      image: "https://images.unsplash.com/photo-1546094096-0df4bcabd1c2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8dG9tYXRvfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 24,
      title: "Lechuga Romana",
      price: 1.50,
      description: "Lechuga romana fresca y crujiente, ideal para ensaladas y wraps.",
      category: "Verduras",
      image: "https://images.unsplash.com/photo-1560806984-22269128708e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGxldHR1Y2V8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 25,
      title: "Arroz Integral",
      price: 4.99,
      description: "Arroz integral de grano largo, fuente de fibra y energía.",
      category: "Granos",
      image: "https://images.unsplash.com/photo-1586201375761-83865001e31c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fHJpY2V8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 26,
      title: "Avena en Hojuelas",
      price: 3.75,
      description: "Avena en hojuelas natural, perfecta para desayunos nutritivos.",
      category: "Granos",
      image: "https://images.unsplash.com/photo-1630869335762-1743d48902a9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8b2F0c3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 27,
      title: "Pasta Integral",
      price: 3.49,
      description: "Pasta de trigo integral, ideal para comidas saludables y deliciosas.",
      category: "Pastas",
      image: "https://images.unsplash.com/photo-1592419434968-9b546174d5c5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHBhc3RhfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
    ),
    Product(
      id: 28,
      title: "Espagueti",
      price: 2.99,
      description: "Espagueti de trigo duro, perfecto para tus salsas favoritas.",
      category: "Pastas",
      image: "https://images.unsplash.com/photo-1603064752734-562782899c47?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fHNwYWdoZXR0aXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60",
    ),
  ];

  List<String> get _categories => ['Todos', ..._products.map((product) => product.category).toSet().toList()];

  List<Product> get _filteredProducts => _selectedCategory == 'Todos'
      ? _products
      : _products.where((product) => product.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2; // Por defecto 2 columnas

    if (screenWidth > 1200) {
      crossAxisCount = 4; // 4 columnas en pantallas grandes
    } else if (screenWidth > 900) {
      crossAxisCount = 3; // 3 columnas en tabletas grandes
    } else if (screenWidth > 600) {
      crossAxisCount = 2; // 2 columnas en tabletas pequeñas y móviles grandes
    } else {
      crossAxisCount = 1; // 1 columna en móviles
    }

    return Scaffold(
      appBar: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encuentra los mejores productos frescos para tu hogar. Calidad garantizada y precios justos.',
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
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: screenWidth > 600 ? 0.65 : 0.85, // Ajuste para diferentes tamaños de pantalla
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts.elementAt(index);
                  return _buildProductCard(product, cartProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, CartProvider cartProvider) {
    return Card(
      elevation: 8, // Aumentamos la elevación para que destaquen más
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Container( // Usamos un Container como padre para dar un color de fondo
        color: Colors.white, // Color de fondo de la tarjeta
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Aumentamos el padding dentro de la tarjeta
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Center( // Centramos la imagen
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain, // Usamos BoxFit.contain para mostrar la imagen completa
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: Text('Imagen no disponible')),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12), // Aumentamos el espacio entre la imagen y el texto
              Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 1.1 * 16.0,
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
                  fontSize: 0.9 * 14.0,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12), // Aumentamos el espacio antes del precio y el botón
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 1.1 * 16.0,
                      color: AppStyles.primaryColor,
                    ),
                  ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Aumentamos el padding del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(fontSize: 0.9 * 14.0),
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

