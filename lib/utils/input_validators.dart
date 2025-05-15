class InputValidators {
  // Valida que el campo no esté vacío
  static String? isNotEmpty(String? value, {String fieldName = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName no puede estar vacío.';
    }
    return null;
  }

  // Valida formato de email
  static String? isValidEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingresa tu email.';
    }
    if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
      return 'Por favor, ingresa un email válido.';
    }
    return null;
  }

  // Valida contraseña con mínimo 6 caracteres
  static String? isValidPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingresa tu contraseña.';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    return null;
  }

  // Valida nombre solo con letras y espacios
  static String? isValidName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingresa tu nombre.';
    }
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$').hasMatch(value)) {
      return 'El nombre solo puede contener letras y espacios.';
    }
    return null;
  }

  // Valida que la confirmación de contraseña coincida
  static String? isPasswordConfirmed(String? value, String? password) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, confirma tu contraseña.';
    }
    if (value != password) {
      return 'Las contraseñas no coinciden.';
    }
    return null;
  }
}
