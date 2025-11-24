class AppRoutes {
  AppRoutes._();

  // Rutas principales
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';

  // Productos
  static const String products = '/products';
  static const String createProduct = '/products/create';
  static const String editProduct = '/products/edit';

  // Categorías
  static const String categories = '/categories';
  static const String createCategory = '/categories/create';
  static const String editCategory = '/categories/edit';

  // Ventas
  static const String sales = '/sales';
  static const String createSale = '/sales/create';
  static const String saleDetail = '/sales/detail';

  // Reportes
  static const String reports = '/reports';

  // Configuración
  static const String settings = '/settings';

  // Usuarios
  static const String users = '/users';
  static const String createUser = '/users/create';
}
