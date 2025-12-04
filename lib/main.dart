// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'core/services/auth_service.dart';
import 'core/theme/theme_manager.dart';

// --- Páginas de la aplicación ---
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/products/presentation/pages/products_list_page.dart';
import 'features/categories/presentation/pages/categories_list_page.dart';
import 'features/sales/presentation/pages/sales_list_page.dart';
import 'features/users/presentation/pages/users_list_page.dart';
import 'features/reports/presentation/pages/reports_page.dart';
import 'features/configuration/presentation/pages/configuration_page.dart';
import 'features/chatbot/presentation/pages/chatbot_page.dart';

// --- Importación del Localizador de Servicios ---
import 'locator.dart';

Future<void> main() async {
  // Aseguramos que los bindings de Flutter estén listos antes de cualquier 'await'.
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ PASO CLAVE: INICIALIZAR EL LOCALIZADOR DE SERVICIOS
  // Esto prepara la instancia única (singleton) de tu ChatbotService.
  setupLocator();

  // --- Carga de preferencias de usuario (Tema y Autenticación) ---
  final prefs = await SharedPreferences.getInstance();
  final String themeName = prefs.getString('themeMode') ?? 'light';
  final ThemeMode initialThemeMode = ThemeMode.values.firstWhere(
        (e) => e.name == themeName,
    orElse: () => ThemeMode.light,
  );

  final isAuthenticated = await AuthService.isAuthenticated();
  final initialRoute = isAuthenticated ? AppRoutes.dashboard : AppRoutes.login;

  // --- Ejecución de la aplicación ---
  // El Provider para el tema ya está correctamente configurado.
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(initialThemeMode),
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios del tema a través del Provider.
    final themeManager = context.watch<ThemeManager>();

    return MaterialApp(
      title: 'Punto de Venta',
      debugShowCheckedModeBanner: false,

      // --- Configuración de Temas ---
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.themeMode, // El tema se aplica dinámicamente.

      // --- Configuración de Rutas ---
      initialRoute: initialRoute,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.dashboard: (context) => const DashboardPage(),
        AppRoutes.products: (context) => const ProductsListPage(),
        AppRoutes.categories: (context) => const CategoriesListPage(),
        AppRoutes.sales: (context) => const SalesListPage(),
        AppRoutes.users: (context) => const UsersListPage(),
        AppRoutes.reports: (context) => const ReportsPage(),
        AppRoutes.settings: (context) => const ConfigurationPage(),
        // La ruta del chatbot sigue siendo la misma.
        '/chatbot': (context) => const ChatBotPage(),
      },
    );
  }
}
