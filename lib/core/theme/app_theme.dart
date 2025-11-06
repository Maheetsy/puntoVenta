import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  // ============== THEME CLARO ==============
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Fuente por defecto
    fontFamily: 'Inter', // Cambiar según prefieras

    // Esquema de colores
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      surface: AppColors.background,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
      outline: AppColors.border,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.background,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textOnPrimary,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
    ),

    // Botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // Botones de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.labelMedium,
      ),
    ),

    // Botones outlined
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTextStyles.labelMedium,
      ),
    ),

    // FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 4,
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: AppTextStyles.bodyMedium,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textDisabled,
      ),
      errorStyle: AppTextStyles.error,
    ),

    // Dividers
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.categoryChip,
      selectedColor: AppColors.primary,
      labelStyle: AppTextStyles.categoryChip,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // ListTile
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: AppTextStyles.titleMedium,
      subtitleTextStyle: AppTextStyles.bodySmall,
    ),

    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: Colors.white,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Dialog - CORREGIDO
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.background,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: AppTextStyles.titleLarge,
      contentTextStyle: AppTextStyles.bodyMedium,
    ),

    // Tipografía general
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),
  );

  // ============== THEME OSCURO ==============
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryDark,
      surface: AppColors.darkBackground,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.darkTextPrimary,
      onError: Colors.white,
      outline: AppColors.borderDark,
    ),

    scaffoldBackgroundColor: AppColors.darkBackground,

    cardTheme: CardThemeData(
      color: AppColors.darkCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkCardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.darkTextPrimary,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.darkTextPrimary,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.darkTextPrimary),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.darkTextPrimary),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.darkTextPrimary),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.darkTextPrimary),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.darkTextPrimary),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.darkTextPrimary),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.darkTextPrimary),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.darkTextPrimary),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.darkTextPrimary),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkTextPrimary),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.darkTextSecondary),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.darkTextPrimary),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.darkTextPrimary),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.darkTextSecondary),
    ),
  );
}