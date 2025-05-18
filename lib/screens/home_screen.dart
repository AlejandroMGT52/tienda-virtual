import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_virtual_flutter/utils/app_styles.dart';
import 'package:tienda_virtual_flutter/screens/shop_screen.dart';
import 'package:tienda_virtual_flutter/components/navbar.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:tienda_virtual_flutter/providers/data_provider.dart';
import 'package:tienda_virtual_flutter/models/product.dart';
import 'package:tienda_virtual_flutter/models/promotion.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Cloud Firestore para las categorías

class Benefit {
  final IconData icon;
  final String title;
  final String description;

  Benefit({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _showBanner = false;
  late AnimationController _animationController;
  late Animation<Offset> _titleAnimation;
  late Animation<Offset> _descriptionAnimation;

  final List<Benefit> _benefits = [
    Benefit(icon: Icons.local_shipping_outlined, title: 'Envío Rápido', description: 'Entrega en 24-48 horas en ciudades principales.'),
    Benefit(icon: Icons.verified_outlined, title: 'Calidad Garantizada', description: 'Productos frescos y de la mejor calidad.'),
    Benefit(icon: Icons.support_agent_outlined, title: 'Soporte 24/7', description: 'Atención al cliente disponible en todo momento.'),
    Benefit(icon: Icons.thumb_up_alt_outlined, title: 'Excelentes Precios', description: 'Los mejores precios del mercado.'),
  ];

  // Lista de URLs de las imágenes destacadas
  final List<String> _featuredImageUrls = [
    'https://pbs.twimg.com/media/ECHwtNcUYAEB8qX.jpg:large',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVLA5kKqR9NavabfMlykQb2-Lb6X4Uf0P8dA&s',
    'https://delicatezza.ec/cdn/shop/files/0Y7A4714-Canasta-Frutas.jpg?v=1708450046',
    'https://www.festiregalos.com.mx/cdn/shop/files/513e776f-e708-45b2-acad-484dbe4a4b8c.jpg?v=1725159774',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _titleAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _descriptionAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showBanner = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userEmail');
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final dataProvider = Provider.of<DataProvider>(context);

    if (dataProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (dataProvider.error != null) {
      return Scaffold(body: Center(child: Text('Error: ${dataProvider.error}')));
    }

    final List<Product> featuredProducts = dataProvider.products.where((p) => p.discount != null && p.discount! > 0).toList(); // Ejemplo: destacados con descuento
    final List<Promotion> promotions = dataProvider.promotions;

    return Scaffold(
      appBar: const NavBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: isMobile ? 120 : 160,
              decoration: BoxDecoration(
                color: AppStyles.primaryColor,
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo-nuevo.png'),
                  fit: BoxFit.cover,
                  opacity: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categorías',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 16 : 18,
                  color: AppStyles.textColor.withOpacity(0.8),
                ),
              ),
            ),
            const Divider(indent: 16.0, endIndent: 16.0),
            ListTile(
              leading: const Icon(Icons.food_bank_outlined, color: AppStyles.secondaryColor), // Icono para Lácteos
              title: Text(
                'Lácteos',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: AppStyles.textColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopScreen(category: 'Lácteos')),
                );
              },
              hoverColor: Colors.grey[100],
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu, color: AppStyles.secondaryColor), // Icono para Pastas
              title: Text(
                'Pastas',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: AppStyles.textColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopScreen(category: 'Pastas')),
                );
              },
              hoverColor: Colors.grey[100],
            ),
            ListTile(
              leading: const Icon(Icons.bakery_dining, color: AppStyles.secondaryColor), // Icono para Panadería
              title: Text(
                'Panadería',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: AppStyles.textColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopScreen(category: 'Panadería')),
                );
              },
              hoverColor: Colors.grey[100],
            ),
            ListTile(
              leading: const Icon(Icons.local_grocery_store, color: AppStyles.secondaryColor), // Icono para Frutas
              title: Text(
                'Frutas',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: AppStyles.textColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopScreen(category: 'Frutas')),
                );
              },
              hoverColor: Colors.grey[100],
            ),
            const SizedBox(height: 16),
            const Divider(indent: 16.0, endIndent: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  _logout(context);
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeIn(
                duration: const Duration(milliseconds: 800),
                child: SlideTransition(
                  position: _titleAnimation,
                  child: Text(
                    '¡Bienvenido a FreshMarket!',
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 40,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.primaryColorShade800,
                      shadows: const [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black12,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeIn(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 800),
                child: SlideTransition(
                  position: _descriptionAnimation,
                  child: Text(
                    'Descubre una experiencia de compra en línea para productos frescos y de calidad. ¡Tu mercado de confianza!',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 18,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ZoomIn(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShopScreen(category: '',)),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  label: Text(
                    '¡Explorar Productos!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.secondaryColor,
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 30 : 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 6,
                    shadowColor: AppStyles.secondaryColorShade300,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_showBanner)
                FadeInDown(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppStyles.primaryColorShade400, AppStyles.secondaryColorShade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppStyles.primaryColorShade200.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '🎉 ¡Oferta de Bienvenida! Disfruta de un 15% de descuento en tu primera compra. ¡No te lo pierdas! 🎉',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Nuestros Productos Destacados',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.textColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppStyles.primaryColor,
                  decorationThickness: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              if (dataProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (dataProvider.error != null)
                Center(child: Text('Error al cargar productos: ${dataProvider.error}'))
              else if (featuredProducts.isEmpty)
                const Center(child: Text(''))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 2 : 4,
                    crossAxisSpacing: isMobile ? 8 : 10,
                    mainAxisSpacing: isMobile ? 8 : 10,
                    childAspectRatio: isMobile ? 1 : 1.1,
                  ),
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    final product = featuredProducts[index];
                    final discountedPrice = dataProvider.applyDiscount(product);
                    final hasDiscount = discountedPrice < product.price;
                    return _buildProductCard(product, context, isMobile, discountedPrice, hasDiscount);
                  },
                ),
              const SizedBox(height: 16),
              // Nueva sección de imágenes destacadas con GridView
              Text(
                '',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.textColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppStyles.secondaryColor,
                  decorationThickness: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Mostramos 4 imágenes por fila
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1, // Para que las imágenes sean cuadradas (aproximadamente)
                ),
                itemCount: _featuredImageUrls.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _featuredImageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.image_not_supported, color: Colors.grey));
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                '¿Por qué elegir FreshMarket?',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.textColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppStyles.secondaryColor,
                  decorationThickness: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ?
                  2 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isMobile ? 2 : 3,
                ),
                itemCount: _benefits.length,
                itemBuilder: (context, index) {
                  final benefit = _benefits[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 200 * index),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(benefit.icon, size: 32, color: AppStyles.secondaryColor),
                            const SizedBox(height: 8),
                            Text(
                              benefit.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 14 : 16,
                                color: AppStyles.textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              benefit.description,
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 14,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              const Text(
                '¡Síguenos en nuestras redes sociales!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook, color: Colors.blue, size: 30),
                    onPressed: () {
                      // TODO: Implementar funcionalidad para abrir Facebook
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.purple, size: 30),
                    onPressed: () {
                      // TODO: Implementar funcionalidad para abrir Instagram
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.mail_outline, color: Colors.redAccent, size: 30),
                    onPressed: () {
                      // TODO: Implementar funcionalidad para abrir correo electrónico
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                '© 2023 FreshMarket - Todos los derechos reservados.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, BuildContext context, bool isMobile, double discountedPrice, bool hasDiscount) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Implementar navegación a la página de detalles del producto
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.image_not_supported));
                    },
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discount}%',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 14 : 16,
                      color: AppStyles.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (hasDiscount)
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade600,
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                      const SizedBox(width: 4),
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppStyles.secondaryColor,
                          fontSize: isMobile ? 14 : 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}