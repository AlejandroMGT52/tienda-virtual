import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_virtual_flutter/utils/input_validators.dart';
import 'package:tienda_virtual_flutter/screens/login_screen.dart'; // Importa LoginScreen

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
  bool _isLoading =
      false; // Para mostrar un indicador de carga durante el registro
  String _errorMessage =
      ''; // Para mostrar mensajes de error al usuario

  void _togglePasswordVisibility(bool confirm) {
    setState(() {
      if (confirm) {
        _obscureConfirmPassword = !_obscureConfirmPassword;
      } else {
        _obscurePassword = !_obscurePassword;
      }
    });
  }

  // Función para registrar al usuario
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = ''; // Limpia el mensaje de error
      });

      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      // Simula una llamada a un servicio de registro (REEMPLAZA CON TU LÓGICA REAL)
      try {
        // Simula una espera de 2 segundos
        await Future.delayed(const Duration(seconds: 2));

        // *** AQUÍ DEBES INTEGRAR TU LÓGICA DE REGISTRO REAL ***
        // 1. Enviar 'name', 'email' y 'password' a tu servidor de registro.
        // 2. Recibir una respuesta (éxito o fallo).
        // 3. Si es exitoso:
        //    - Guardar la información del usuario en SharedPreferences.
        //    - Navegar a la pantalla de inicio de sesión.
        // 4. Si falla:
        //    - Mostrar un mensaje de error.

        // Simulación de éxito (para pruebas)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', name);
        await prefs.setString('userEmail', email);
        await prefs.setString('userPassword', password); // NO GUARDAR CONTRASEÑAS EN TEXTO PLANO EN LA VIDA REAL
        await prefs.setBool('isLoggedIn',
            true); //Para que al registrarse inicie sesión de una vez.

        if (mounted) {
          // Muestra un mensaje de éxito y navega al Login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro exitoso. Por favor, inicia sesión.'),
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pushReplacementNamed(context, '/login'); // O usa pushReplacement
        }
      } catch (error) {
        // Capturar errores
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: ${error.toString()}';
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
                              onPressed: () => _togglePasswordVisibility(false),
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
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => _togglePasswordVisibility(true),
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
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                ) // Muestra el indicador
                              : const Text('Registrarse',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                        ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('¿Ya tienes una cuenta? Inicia sesión'),
                        ),
                         if (_errorMessage.isNotEmpty) // Muestra el mensaje de error
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