import 'package:flutter/material.dart';

class AppColors {
  // Constructor privado para evitar instanciación
  AppColors._();

  // ============== COLORES BASE ==============

  // Backgrounds
  static const Color background = Color(0xFFEAF4F4); // #EAF4F4
  static const Color backgroundSecondary = Color(0xFFC0D6DF); // #C0D6DF
  static const Color cardBackground = Color(0xFFA2D6F9); // #A2D6F9

  // Primary (Azul) - #1B98E0 y #1E96FC para botones
  static const Color primary = Color(0xFF1B98E0); // #1B98E0
  static const Color primaryLight = Color(0xFF1E96FC); // #1E96FC
  static const Color primaryDark = Color(0xFF007FFF);
  static const Color primaryContainer = Color(0xFFC0D6DF); // #C0D6DF

  // Secondary (Verde azulado)
  static const Color secondary = Color(0xFF00A896);
  static const Color secondaryLight = Color(0xFF33BBA9);
  static const Color secondaryDark = Color(0xFF008577);
  static const Color secondaryContainer = Color(0xFFCCF2ED);

  // Texto
  static const Color textPrimary = Color(0xFF000000); // Negro
  static const Color textSecondary = Color(0xFF495057);
  static const Color textTertiary = Color(0xFF6C757D);
  static const Color textDisabled = Color(0xFFADB5BD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Surface y on
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Accent
  static const Color accent = primary;

  // Divider
  static const Color outline = divider;

  // ============== ESTADOS Y FEEDBACK ==============

  // Success (usando tu verde azulado)
  static const Color success = Color(0xFF00A896);
  static const Color successLight = Color(0xFFE6F7F5);
  static const Color successDark = Color(0xFF007B6E);

  // Error
  static const Color error = Color(0xFFDC3545);
  static const Color errorLight = Color(0xFFF8D7DA);
  static const Color errorDark = Color(0xFFC82333);

  // Warning
  static const Color warning = Color(0xFFFFC107);
  static const Color warningLight = Color(0xFFFFF3CD);
  static const Color warningDark = Color(0xFFE0A800);

  // Info
  static const Color info = Color(0xFF17A2B8);
  static const Color infoLight = Color(0xFFD1ECF1);
  static const Color infoDark = Color(0xFF117A8B);

  // ============== ELEMENTOS UI ==============

  // Bordes
  static const Color border = Color(0xFFDEE2E6);
  static const Color borderLight = Color(0xFFE9ECEF);
  static const Color borderDark = Color(0xFFADB5BD);

  // Divisores
  static const Color divider = Color(0xFFE9ECEF);

  // Sombras
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x33000000);

  // Overlays
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // ============== ELEMENTOS ESPECÍFICOS DEL POS ==============

  // Productos y categorías
  static const Color productCard = Color(0xFFA2D6F9); // #A2D6F9
  static const Color categoryChip = Color(0xFFC0D6DF); // #C0D6DF

  // Estados de inventario
  static const Color inStock = success;
  static const Color lowStock = warning;
  static const Color outOfStock = error;

  // Transacciones
  static const Color income = success;
  static const Color expense = error;
  static const Color pending = warning;

  // Métodos de pago
  static const Color cash = Color(0xFF28A745);
  static const Color card = Color(0xFF6F42C1);
  static const Color transfer = Color(0xFF17A2B8);

  // ============== GRADIENTES ==============

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF33BBA9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============== COLORES MODO OSCURO (OPCIONAL) ==============

  static const Color darkBackground = Color(0xFF011627);
  static const Color darkCardBackground = Color(0xFF1E2D3D);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFCED4DA);
  static const Color darkSurface = Color(0xFF1E2D3D);
  static const Color darkDivider = Color(0xFF3D4A5C);
}
