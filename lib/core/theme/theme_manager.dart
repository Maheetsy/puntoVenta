import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Esta es la clave que usaremos para guardar en memoria
const String _kThemeModeKey = 'themeMode';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode;

  // El constructor recibe el tema inicial (que cargaremos en main.dart)
  ThemeManager(this._themeMode);

  // Getter para que el resto de la app lea el tema actual
  ThemeMode get themeMode => _themeMode;

  // Función para cambiar el tema
  Future<void> setTheme(ThemeMode themeMode) async {
    // Si es el mismo, no hacemos nada
    if (themeMode == _themeMode) return;

    _themeMode = themeMode;
    // Notifica a todos los "oyentes" (widgets) que el tema cambió
    notifyListeners();

    // Guarda la preferencia en el disco
    final prefs = await SharedPreferences.getInstance();
    // Guardamos el nombre del enum, ej: "dark", "light", "system"
    prefs.setString(_kThemeModeKey, themeMode.name);
  }
}