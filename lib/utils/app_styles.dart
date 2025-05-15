// lib/utils/app_styles.dart
import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Color(0xFF3DB54A); // Verde primario
  static const Color primaryColorShade200 = Color(0xFF82E98E); // Un verde más claro
  static const Color primaryColorShade300 = Color(0xFF60D96B);
  static const Color primaryColorShade400 = Color(0xFF4BCB57);
  static const Color primaryColorShade800 = Color(0xFF2A8A35); // Un verde más oscuro

  static const Color secondaryColor = Color(0xFFF9A826); // Amarillo/naranja
  static const Color secondaryColorShade300 = Color(0xFFFFC753); // Un amarillo/naranja más claro
  static const Color secondaryColorShade400 = Color(0xFFFFB733);
  static const Color secondaryColorShade800 = Color(0xFFC77900); // Un amarillo/naranja más oscuro

  static const Color textColor = Color(0xFF333333); // Gris oscuro
  static const Color lightColor = Color(0xFFF4F4F4); // Gris claro
  static const Color dangerColor = Color(0xFFE74C3C); // Rojo
  static const Color successColor = Color(0xFF27AE60); // Verde éxito

  static const TextStyle titleLarge = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    color: textColor,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    color: Colors.grey,
    height: 1.4,
  );

  static const TextStyle navbarLogo = TextStyle(
    fontFamily: 'YourCustomFont', // Reemplaza con tu fuente si la tienes
    fontSize: 22.0,
    fontWeight: FontWeight.w800,
    color: textColor,
  );
}