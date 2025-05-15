import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_virtual_flutter/utils/app_styles.dart';
import 'package:tienda_virtual_flutter/screens/shop_screen.dart';
import 'package:tienda_virtual_flutter/components/navbar.dart';
import 'package:animate_do/animate_do.dart'; // Importa la librería animate_do

class Category {
  final int id;
  final String name;
  final String description;
  final String image;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.icon = Icons.category_outlined,
  });
}

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

  // Función para cerrar sesión
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // Limpiar el estado de inicio de sesión
    await prefs.setBool('isLoggedIn', false);
    // Opcional: Limpiar otra información del usuario si es necesario
    await prefs.remove('userEmail'); 

    // Navegar a la pantalla de inicio de sesión
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login'); // Asegúrate de tener la ruta '/login' definida
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

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
            ..._categories.map((category) => ListTile(
                  leading: ElasticIn(
                    child: Icon(category.icon, color: AppStyles.secondaryColor),
                  ),
                  title: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: AppStyles.textColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    print('Navegar a la categoría: ${category.name}');
                  },
                  hoverColor: Colors.grey[100],
                )),
            const SizedBox(height: 16),
            const Divider(indent: 16.0, endIndent: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  _logout(context); // Llama a la función _logout
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
          padding: EdgeInsets.all(isMobile ? 12.0 : 16.0), // Ajuste de padding para móvil
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
                      MaterialPageRoute(builder: (context) => const ShopScreen()),
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
              const SizedBox(height: 32),
              Text(
                'Nuestras Categorías Destacadas',
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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 2 : 4,
                  crossAxisSpacing: isMobile ? 8 : 10,
                  mainAxisSpacing: isMobile ? 8 : 10,
                  childAspectRatio: isMobile ? 1 : 1.1,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return _buildCategoryCard(category, context, isMobile);
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
                  crossAxisCount: isMobile ? 2 : 4,
                  crossAxisSpacing: isMobile ? 10 : 12,
                  mainAxisSpacing: isMobile ? 10 : 12,
                  childAspectRatio: isMobile ? 1.3 : 1.5,
                ),
                itemCount: _benefits.length,
                itemBuilder: (context, index) {
                  final benefit = _benefits[index];
                  return _buildBenefitCard(benefit, isMobile);
                },
              ),
              const SizedBox(height: 32),
              BounceInUp(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShopScreen()),
                    );
                  },
                  icon: const Icon(Icons.visibility_outlined, color: AppStyles.secondaryColor),
                  label: Text(
                    'Ver Toda Nuestra Selección',
                    style: TextStyle(
                      color: AppStyles.secondaryColor,
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 25 : 35, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: AppStyles.secondaryColor, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category, BuildContext context, bool isMobile) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShopScreen()),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  category.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.image_not_supported, size: 24, color: Colors.grey));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                category.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 12 : 14,
                  color: AppStyles.textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (category.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Text(
                  category.description,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard(Benefit benefit, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(benefit.icon, size: isMobile ? 36 : 48, color: AppStyles.secondaryColor),
          const SizedBox(height: 8),
          Text(
            benefit.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 12 : 14,
              color: AppStyles.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            benefit.description,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: isMobile ? 10 : 12,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  final List<Category> _categories = [
    Category(
        id: 1,
        name: 'Frutas Frescas',
        description: 'Lo mejor de la temporada.',
        image:
            'https://www.telemundo.com/sites/nbcutelemundo/files/images/promo/article/2017/04/13/naranja-manzana-y-otras-frutas-frescas.jpg',
        icon: Icons.local_grocery_store_outlined),
    Category(
        id: 2,
        name: 'Verduras Orgánicas',
        description: 'Directo del campo a tu mesa.',
        image: 'https://strapi.fitia.app/uploads/verduras_402de1696c.jpg',
        icon: Icons.eco_outlined),
    Category(
        id: 3,
        name: 'Panadería Artesanal',
        description: 'Horneado con amor cada día.',
        image:
            'https://tb-static.uber.com/prod/image-proc/processed_images/8f27b5720353d0b843e26cd8ad9ba262/fb86662148be855d931b37d6c1e5fcbe.jpeg',
        icon: Icons.bakery_dining_outlined),
    Category(
        id: 4,
        name: 'Lácteos Selectos',
        description: 'Frescura y calidad garantizada.',
        image: 'https://p2.trrsf.com/image/fget/cf/1200/630/middle/images.terra.com/2022/12/08/1814654892-laticinios-1.jpg',
        icon: Icons.local_drink_outlined),
    // Agrega más categorías aquí con sus respectivos iconos
  ];

  final List<Benefit> _benefits = [
    Benefit(
      icon: Icons.local_shipping_rounded,
      title: 'Envío Rápido',
      description: 'Recibe tus compras rápidamente y con seguridad.',
    ),
    Benefit(
      icon: Icons.check_circle_outline_rounded,
      title: 'Calidad Premium',
      description: 'Productos frescos y de la más alta calidad para ti y tu familia.',
    ),
    Benefit(
      icon: Icons.monetization_on_outlined,
      title: 'Precios Justos',
      description: 'Disfruta de excelentes precios sin sacrificar la calidad de nuestros productos.',
    ),
    Benefit(
      icon: Icons.support_agent_rounded,
      title: 'Soporte Amigable',
      description: 'Nuestro equipo está listo para ayudarte con cualquier duda o consulta.',
    ),
  ];
}

// Widget para la animación Fade In
class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration? delay;

  const FadeIn({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay,
  }) : super(key: key);

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.delay == null) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay!, () {
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}