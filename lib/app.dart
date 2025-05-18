import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_virtual_flutter/screens/home_screen.dart';
import 'package:tienda_virtual_flutter/screens/shop_screen.dart';
import 'package:tienda_virtual_flutter/screens/cart_screen.dart';
import 'package:tienda_virtual_flutter/components/navbar.dart';
import 'package:tienda_virtual_flutter/providers/cart_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'FreshMarket',
        theme: ThemeData(
          primaryColor: const Color(0xFF3DB54A),
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFF9A826)),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: const Color(0xFF333333)), // Corrección: bodyLarge
          ),
          fontFamily: 'Segoe UI',
        ),
        //  home: const MainScreen(), // No uses home y routes juntos.  Decide uno.
        initialRoute:
            '/', // Define una ruta inicial.  Generalmente es '/'.  Si usas routes, initialRoute es MEJOR.
        routes: {
          '/': (context) =>
              const MainScreen(), // La barra diagonal sola, es la principal
          '/home': (context) => const HomeScreen(),
          '/shop': (context) =>
              const ShopScreen(category: 'Todos'), //  Aquí está la corrección IMPORTANTE
          '/cart': (context) => const CartScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ShopScreen(
        category:
            'Todos'), //  Corrección:  ShopScreen SIEMPRE necesita category
    const CartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Tienda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}