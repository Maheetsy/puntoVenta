class AppStrings {
  AppStrings._();

  // ============== GENERAL ==============
  static const String appName = 'Punto de Venta';
  static const String welcome = 'Bienvenido';
  static const String loading = 'Cargando...';
  static const String error = 'Error';
  static const String success = 'Éxito';
  static const String cancel = 'Cancelar';
  static const String save = 'Guardar';
  static const String edit = 'Editar';
  static const String delete = 'Eliminar';
  static const String create = 'Crear';
  static const String search = 'Buscar';
  static const String filter = 'Filtrar';
  static const String actions = 'Acciones';
  static const String confirm = 'Confirmar';
  static const String back = 'Volver';
  static const String next = 'Siguiente';
  static const String previous = 'Anterior';
  static const String close = 'Cerrar';
  static const String yes = 'Sí';
  static const String no = 'No';

  // ============== NAVEGACIÓN ==============
  static const String navDashboard = 'Inicio';
  static const String navProducts = 'Productos';
  static const String navCategories = 'Categorías';
  static const String navSales = 'Ventas';
  static const String navClients = 'Clientes';
  static const String navUsers = 'Usuarios';
  static const String navReports = 'Reportes';
  static const String navSettings = 'Configuración';

  // ============== DASHBOARD ==============
  static const String dashboardTitle = 'Panel de Control';
  static const String totalSales = 'Ventas Totales';
  static const String totalProducts = 'Total Productos';
  static const String totalClients = 'Total Clientes';
  static const String lowStock = 'Stock Bajo';
  static const String recentSales = 'Ventas Recientes';
  static const String topProducts = 'Productos Más Vendidos';

  // ============== PRODUCTOS ==============
  static const String productsTitle = 'Productos';
  static const String productList = 'Lista de Productos';
  static const String createProduct = 'Crear Producto';
  static const String editProduct = 'Editar Producto';
  static const String productName = 'Nombre del Producto';
  static const String productDescription = 'Descripción';
  static const String productPrice = 'Precio';
  static const String productStock = 'Stock';
  static const String productCategory = 'Categoría';
  static const String productBarcode = 'Código de Barras';
  static const String productImage = 'Imagen';
  static const String productCreated = 'Producto creado exitosamente';
  static const String productUpdated = 'Producto actualizado exitosamente';
  static const String productDeleted = 'Producto eliminado exitosamente';
  static const String deleteProductConfirm =
      '¿Está seguro de eliminar este producto?';
  static const String noProducts = 'No hay productos registrados';

  // ============== CATEGORÍAS ==============
  static const String categoriesTitle = 'Categorías';
  static const String categoryList = 'Lista de Categorías';
  static const String createCategory = 'Crear Categoría';
  static const String editCategory = 'Editar Categoría';
  static const String categoryName = 'Nombre de la Categoría';
  static const String categoryDescription = 'Descripción';
  static const String categoryCreated = 'Categoría creada exitosamente';
  static const String categoryUpdated = 'Categoría actualizada exitosamente';
  static const String categoryDeleted = 'Categoría eliminada exitosamente';
  static const String deleteCategoryConfirm =
      '¿Está seguro de eliminar esta categoría?';
  static const String noCategories = 'No hay categorías registradas';

  // ============== CLIENTES ==============
  static const String clientsTitle = 'Clientes';
  static const String clientList = 'Lista de Clientes';
  static const String createClient = 'Crear Cliente';
  static const String editClient = 'Editar Cliente';
  static const String clientName = 'Nombre Completo';
  static const String clientEmail = 'Correo Electrónico';
  static const String clientPhone = 'Teléfono';
  static const String clientAddress = 'Dirección';
  static const String clientCreated = 'Cliente creado exitosamente';
  static const String clientUpdated = 'Cliente actualizado exitosamente';
  static const String clientDeleted = 'Cliente eliminado exitosamente';
  static const String deleteClientConfirm =
      '¿Está seguro de eliminar este cliente?';
  static const String noClients = 'No hay clientes registrados';

  // ============== VENTAS ==============
  static const String salesTitle = 'Ventas';
  static const String salesList = 'Lista de Ventas';
  static const String createSale = 'Nueva Venta';
  static const String saleDetail = 'Detalle de Venta';
  static const String saleNumber = 'Número de Venta';
  static const String saleDate = 'Fecha';
  static const String saleClient = 'Cliente';
  static const String saleTotal = 'Total';
  static const String saleStatus = 'Estado';
  static const String saleItems = 'Productos';
  static const String saleCreated = 'Venta creada exitosamente';
  static const String noSales = 'No hay ventas registradas';
  static const String addProduct = 'Agregar Producto';
  static const String quantity = 'Cantidad';
  static const String subtotal = 'Subtotal';
  static const String total = 'Total';
  static const String paymentMethod = 'Método de Pago';
  static const String cash = 'Efectivo';
  static const String card = 'Tarjeta';
  static const String transfer = 'Transferencia';

  // ============== MENSAJES DE ERROR ==============
  static const String errorGeneric =
      'Ocurrió un error. Por favor, intente nuevamente';
  static const String errorNetwork = 'Error de conexión. Verifique su internet';
  static const String errorNotFound = 'No se encontró el recurso solicitado';
  static const String errorUnauthorized =
      'No tiene permisos para realizar esta acción';
  static const String errorValidation =
      'Por favor, complete todos los campos correctamente';

  // ============== MENSAJES DE ÉXITO ==============
  static const String successGeneric = 'Operación realizada exitosamente';
  static const String successSave = 'Guardado exitosamente';
  static const String successDelete = 'Eliminado exitosamente';
  static const String successUpdate = 'Actualizado exitosamente';
}
