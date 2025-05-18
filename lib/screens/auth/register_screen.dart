import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_virtual_flutter/utils/input_validators.dart';
import 'package:crypto/crypto.dart'; // Importa el paquete crypto
import 'dart:convert'; // Para la función utf8.encode

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String _errorMessage = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _togglePasswordVisibility(bool confirm) {
    setState(() {
      if (confirm) {
        _obscureConfirmPassword = !_obscureConfirmPassword;
      } else {
        _obscurePassword = !_obscurePassword;
      }
    });
  }

  // Función para hashear la contraseña usando SHA256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Función para registrar al usuario (modificada para usar Firestore)
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final hashedPassword = _hashPassword(password); // Hashea la contraseña
      final registrationDate = DateTime.now();

      try {
        // Verificar si el correo ya existe en Firestore
        final QuerySnapshot<Map<String, dynamic>> userExists = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (userExists.docs.isNotEmpty) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Este correo electrónico ya está registrado.';
          });
          return;
        }

        // Agrega el nuevo usuario a Firestore
        final DocumentReference<Map<String, dynamic>> newUser =
            await _firestore.collection('users').add({
          'name': name,
          'email': email,
          'password': hashedPassword, // Guarda el hash, no la contraseña en texto plano
          'registrationDate': registrationDate,
        });

        // Guardar en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', name);
        await prefs.setString('userEmail', email);
        await prefs.setString('userId', newUser.id); // Guarda el ID del documento
        await prefs.setBool('isLoggedIn', true);

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          // Muestra un mensaje de éxito y navega al Login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Registro exitoso. Por favor, inicia sesión.'),
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pushReplacementNamed(
              context, '/login'); // O usa pushReplacement
        }
      } catch (error) {
        // Capturar errores
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error al registrar: ${error.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo dinámico
          Positioned.fill(
            child: Image.asset(
              'assets/images/logo-nuevo.png',
              fit: BoxFit.cover,
              color: Colors.purple.withOpacity(0.4),
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Crea tu cuenta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre completo',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          validator: InputValidators.isNotEmpty,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          validator: InputValidators.isValidEmail,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () =>
                                  _togglePasswordVisibility(false),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          validator: InputValidators.isValidPassword,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            prefixIcon:
                                const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () =>
                                  _togglePasswordVisibility(true),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obligatorio';
                            }
                            if (value !=
                                _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Registrarse',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white)),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                              '¿Ya tienes una cuenta? Inicia sesión'),
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

