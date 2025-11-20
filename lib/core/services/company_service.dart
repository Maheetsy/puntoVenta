import 'package:shared_preferences/shared_preferences.dart';

class CompanyService {
  static const String _nombreTiendaKey = 'company_name';
  static const String _direccionKey = 'company_address';
  static const String _telefonoKey = 'company_phone';
  static const String _rfcKey = 'company_rfc';

  // Guardar datos de la empresa
  static Future<void> saveCompanyData({
    required String nombreTienda,
    required String direccion,
    required String telefono,
    required String rfc,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nombreTiendaKey, nombreTienda);
    await prefs.setString(_direccionKey, direccion);
    await prefs.setString(_telefonoKey, telefono);
    await prefs.setString(_rfcKey, rfc);
  }

  // Obtener datos de la empresa
  static Future<Map<String, String>> getCompanyData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'nombreTienda': prefs.getString(_nombreTiendaKey) ?? '',
      'direccion': prefs.getString(_direccionKey) ?? '',
      'telefono': prefs.getString(_telefonoKey) ?? '',
      'rfc': prefs.getString(_rfcKey) ?? '',
    };
  }
}

