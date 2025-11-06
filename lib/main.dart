import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/products/presentation/pages/products_list_page.dart';
import 'features/categories/presentation/pages/categories_list_page.dart';
import 'features/sales/presentation/pages/sales_list_page.dart';
import 'features/clients/presentation/pages/clients_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punto de Venta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.dashboard,
      routes: {
        AppRoutes.dashboard: (context) => const DashboardPage(),
        AppRoutes.products: (context) => const ProductsListPage(),
        AppRoutes.categories: (context) => const CategoriesListPage(),
        AppRoutes.sales: (context) => const SalesListPage(),
        AppRoutes.clients: (context) => const ClientsListPage(),
      },
    );
  }
}
