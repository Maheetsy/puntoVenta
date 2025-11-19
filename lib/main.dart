import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <- Importar Provider
import 'package:shared_preferences/shared_preferences.dart'; // <- Importar SharedPreferences

import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';

// --- Importa tus páginas ---
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/products/presentation/pages/products_list_page.dart';
import 'features/categories/presentation/pages/categories_list_page.dart';
import 'features/sales/presentation/pages/sales_list_page.dart';
import 'features/reports/presentation/pages/reports_page.dart';
import 'features/configuration/presentation/pages/configuration_page.dart';

// --- Importa el nuevo ThemeManager ---
import 'core/theme/theme_manager.dart';

// 1. Convertimos main en "async" para poder cargar las preferencias
Future<void> main() async {
  // 2. Aseguramos que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Cargamos la preferencia del tema
  final prefs = await SharedPreferences.getInstance();
  // Buscamos el tema guardado, si no hay, usamos 'light'
  final String themeName = prefs.getString('themeMode') ?? 'light';

  // 4. Convertimos el texto guardado (ej: "dark") a un objeto ThemeMode
  final ThemeMode initialThemeMode = ThemeMode.values.firstWhere(
        (e) => e.name == themeName,
    orElse: () => ThemeMode.light,
  );

  // 5. Envolvemos la app con el "Proveedor" del tema
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(initialThemeMode),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 6. "Escuchamos" los cambios del ThemeManager
    final themeManager = context.watch<ThemeManager>();

    return MaterialApp(
      title: 'Punto de Venta',
      debugShowCheckedModeBanner: false,

      // --- Conexión final ---
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.themeMode, // <-- ¡LA MAGIA OCURRE AQUÍ!
      // -----------------------

      initialRoute: AppRoutes.dashboard,
      routes: {
        AppRoutes.dashboard: (context) => const DashboardPage(),
        AppRoutes.products: (context) => const ProductsListPage(),
        AppRoutes.categories: (context) => const CategoriesListPage(),
        AppRoutes.sales: (context) => const SalesListPage(),
        AppRoutes.reports: (context) => const ReportsPage(),
        AppRoutes.settings: (context) => const ConfigurationPage(),
      },
    );
  }
}