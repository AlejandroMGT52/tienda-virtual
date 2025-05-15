import 'package:flutter/material.dart';
import 'package:tienda_virtual_flutter/utils/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:tienda_virtual_flutter/providers/cart_provider.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Altura estándar de la AppBar
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartCount = cartProvider.cartItems.length; // Usamos la lista directamente

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4, // box-shadow
      title: InkWell(
        onTap: () => Navigator.pushNamed(context, '/home'),
        child: RichText(
          text: const TextSpan(
            style: AppStyles.navbarLogo,
            children: [
              TextSpan(text: 'Fresh'),
              TextSpan(
                text: 'Market',
                style: TextStyle(
                  color: AppStyles.secondaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text('Inicio',
                    style: TextStyle(
                      color: AppStyles.textColor,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/shop'),
                child: const Text('Productos',
                    style: TextStyle(
                      color: AppStyles.textColor,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/promociones'), // Agregado Promociones
                child: const Text('Promociones',
                    style: TextStyle(
                      color: AppStyles.textColor,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, size: 28),
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 0,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppStyles.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 22,
                          minHeight: 22,
                        ),
                        child: Center(
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 0.8 * 16.0, // 0.8rem
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}