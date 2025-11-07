import 'package:flutter/material.dart';
import '../../../../core/constants/app_routes.dart'; // Asegúrate de que la ruta sea correcta
import '../../../../core/widgets/responsive_layout.dart'; // Importa tu layout
// Importa el paquete de PDF (después de agregarlo en pubspec.yaml)
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. USA RESPONSIVE LAYOUT (Esto arregla el menú)
    return ResponsiveLayout(
      // 2. INDICA EL ÍNDICE CORRECTO (para que se marque en el menú)
      currentIndex: 5,
      onNavTap: (index) => _navigateToPage(context, index),
      title: 'Reportes', // Título para el AppBar
      // 3. PASA EL CONTENIDO EN EL BODY
      body: _buildReportsBody(context),
    );
  }

  // Esta es la lógica de navegación que ya tienes en dashboard_page.dart
  // La copiamos aquí para que funcione también desde esta página
  void _navigateToPage(BuildContext context, int index) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    switch (index) {
      case 0:
        if (currentRoute != AppRoutes.dashboard)
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        break;
      case 1:
        if (currentRoute != AppRoutes.products)
          Navigator.pushReplacementNamed(context, AppRoutes.products);
        break;
      case 2:
        if (currentRoute != AppRoutes.categories)
          Navigator.pushReplacementNamed(context, AppRoutes.categories);
        break;
      case 3:
        if (currentRoute != AppRoutes.sales)
          Navigator.pushReplacementNamed(context, AppRoutes.sales);
        break;
      case 4:
        if (currentRoute != AppRoutes.clients)
          Navigator.pushReplacementNamed(context, AppRoutes.clients);
        break;
      case 5: // Reports
      // No hacer nada si ya estamos aquí
        break;
      case 6: // Configuration
        if (currentRoute != AppRoutes.settings)
          Navigator.pushReplacementNamed(context, AppRoutes.settings);
        break;
    }
  }

  // --- Aquí empieza el contenido de la página de Reportes ---
  Widget _buildReportsBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generar Reporte de Ventas',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),

          // --- Selector de Rango de Fechas ---
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Fecha Inicio'),
                onPressed: () { /* Lógica para mostrar DatePicker */ },
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Fecha Fin'),
                onPressed: () { /* Lógica para mostrar DatePicker */ },
              ),
            ],
          ),
          const SizedBox(height: 30),

          // --- Botón para Generar PDF ---
          ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Generar PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: () {
              // --- AQUÍ VA LA LÓGICA DEL PDF ---
              _generarReportePDF(context);
            },
          ),
          const SizedBox(height: 30),

          // --- Otras ideas de "extras" ---
          Text(
            'Productos Más Vendidos (Este Mes)',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Aquí podrías poner una tabla o una gráfica
          Card(
            child: ListTile(
              leading: Icon(Icons.inventory_2),
              title: Text('Producto A'),
              subtitle: Text('150 unidades vendidas'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.inventory_2),
              title: Text('Producto B'),
              subtitle: Text('120 unidades vendidas'),
            ),
          ),
        ],
      ),
    );
  }

  // --- Lógica para el PDF ---
  Future<void> _generarReportePDF(BuildContext context) async {
    // 1. Agrega los paquetes:
    //    flutter pub add pdf
    //    flutter pub add printing

    // 2. Crea el documento PDF
    // final pdf = pw.Document();

    // 3. (Importante) Obtén tus datos
    //    Aquí deberías llamar a tu API/Backend para traer las ventas
    //    final List<Venta> ventas = await tuApi.getVentas();

    // 4. Agrega contenido al PDF
    // pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) {
    //       return pw.Column(
    //         crossAxisAlignment: pw.CrossAxisAlignment.start,
    //         children: [
    //           pw.Text('Reporte de Ventas', style: pw.TextStyle(fontSize: 24)),
    //           pw.SizedBox(height: 20),
    //           pw.Table.fromTextArray(
    //             headers: ['ID Venta', 'Cliente', 'Total'],
    //             data: [ // Esto vendría de tu API
    //               ['1001', 'Cliente A', '\$150.00'],
    //               ['1002', 'Cliente B', '\$200.00'],
    //             ],
    //           ),
    //         ],
    //       );
    //     },
    //   ),
    // );

    // 5. Muestra el PDF para imprimir/guardar
    // await Printing.layoutPdf(
    //   onLayout: (format) async => pdf.save(),
    // );

    // Por ahora, solo muestra un diálogo de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generando PDF... (Lógica no implementada)')),
    );
  }
}