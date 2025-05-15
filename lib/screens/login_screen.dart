import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda_virtual_flutter/utils/input_validators.dart'; // Importa los validadores
import 'package:tienda_virtual_flutter/screens/home_screen.dart'; // Asegúrate de importar HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading =
      false; // Para mostrar un indicador de carga durante el inicio de sesión
  String _errorMessage =
      ''; // Para mostrar mensajes de error al usuario

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Lógica para login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = ''; // Limpia el mensaje de error
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        final prefs = await SharedPreferences.getInstance();

        // *** LÓGICA DE AUTENTICACIÓN CON SHARED_PREFERENCES ***
        // 1. Recuperar el email y la contraseña guardados durante el registro.
        final storedEmail = prefs.getString('userEmail');
        final storedPassword = prefs.getString('userPassword'); // ¡NUNCA guardes contraseñas en texto plano!

        // 2. Comparar las credenciales ingresadas con las guardadas.
        if (storedEmail == email && storedPassword == password) {
          // 3. Si las credenciales coinciden, marcar al usuario como logueado y navegar a la pantalla principal.
          await prefs.setBool('isLoggedIn', true);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          // 4. Si las credenciales no coinciden, mostrar un mensaje de error.
          setState(() {
            _isLoading = false;
            _errorMessage = 'Correo o contraseña incorrectos';
          });
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

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/logo-nuevo.png',
              // Reemplaza con la ruta correcta
              fit: BoxFit.cover,
              color: Colors.blue.withOpacity(0.4),
              // Opcional: ajustar el color
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Bienvenido',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          'Inicia sesión en tu cuenta para continuar',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: InputValidators.isValidEmail,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              onPressed: _togglePasswordVisibility,
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: InputValidators.isValidPassword,
                        ),
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Implementar lógica de "Olvidé mi contraseña"
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        '¿Olvidaste tu contraseña? (Implementar)')),
                              );
                            },
                            child: const Text('¿Olvidaste tu contraseña?',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          // Deshabilita si está cargando
                          style: ElevatedButton.styleFrom(
                            padding:
                                const EdgeInsets.symmetric(vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                ) // Muestra el indicador
                              : const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('¿No tienes una cuenta?'),
                            TextButton(
                              onPressed: _navigateToRegister,
                              child: const Text('Regístrate',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ),
                          ],
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