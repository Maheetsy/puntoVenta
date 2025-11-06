class Validators {
  Validators._();

  // Validar email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  // Validar contraseña
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Validar campo requerido
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    return null;
  }

  // Validar número positivo
  static String? positiveNumber(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Ingrese un número válido';
    }
    if (number <= 0) {
      return 'El valor debe ser mayor a cero';
    }
    return null;
  }

  // Validar número entero positivo
  static String? positiveInteger(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Ingrese un número entero válido';
    }
    if (number < 0) {
      return 'El valor no puede ser negativo';
    }
    return null;
  }

  // Validar teléfono
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Ingrese un teléfono válido';
    }
    return null;
  }

  // Validar longitud mínima
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Este campo'} es requerido';
    }
    if (value.length < minLength) {
      return 'Debe tener al menos $minLength caracteres';
    }
    return null;
  }

  // Validar longitud máxima
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > maxLength) {
      return 'No puede exceder $maxLength caracteres';
    }
    return null;
  }
}

