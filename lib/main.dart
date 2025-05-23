import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_virtual_flutter/screens/home_screen.dart';
import 'package:tienda_virtual_flutter/screens/shop_screen.dart';
import 'package:tienda_virtual_flutter/screens/cart_screen.dart';
import 'package:tienda_virtual_flutter/screens/login_screen.dart';
import 'package:tienda_virtual_flutter/screens/auth/register_screen.dart';
import 'package:tienda_virtual_flutter/screens/promociones_screen.dart';
import 'package:tienda_virtual_flutter/providers/cart_provider.dart';
import 'package:tienda_virtual_flutter/providers/data_provider.dart'; // Importante: Importar DataProvider
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tienda_virtual_flutter/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => DataProvider()), // Agregamos DataProvider aquí
        // Aquí puedes agregar otros Providers si los tienes
      ],
      child: MyApp(initialRoute: isLoggedIn ? '/home' : '/login'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreshMarket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3DB54A),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFF9A826)),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)),
        ),
        fontFamily: 'Segoe UI',
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/shop': (context) => const ShopScreen(category: 'Todos'), // Modificado para incluir la categoría
        '/cart': (context) => const CartScreen(),
        '/promociones': (context) => const PromocionesScreen(),
      },
    );
  }
}