import 'package:flutter/material.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_manager.dart';

// 1. Convertimos a StatefulWidget
class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  // 2. Declaramos los controladores aquí, fuera del 'build'
  late final TextEditingController _nombreTiendaController;
  late final TextEditingController _direccionController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _rfcController;

  @override
  void initState() {
    super.initState();
    // 3. Los inicializamos UNA SOLA VEZ en initState
    _nombreTiendaController = TextEditingController(text: "Mi Tienda POS");
    _direccionController = TextEditingController(text: "Calle Falsa 123");
    _telefonoController = TextEditingController(text: "+12 345 6789");
    _rfcController = TextEditingController(text: "ABC123456XYZ");
  }

  @override
  void dispose() {
    // 4. Los limpiamos en dispose para liberar memoria
    _nombreTiendaController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 5. El 'build' ahora usa los controladores que ya existen
    return ResponsiveLayout(
      currentIndex: 5,
      onNavTap: (index) => _navigateToPage(context, index),
      title: 'Configuración',
      body: _buildConfigurationBody(context),
    );
  }

  // Lógica de navegación (no cambia)
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
        if (currentRoute != AppRoutes.reports)
          Navigator.pushReplacementNamed(context, AppRoutes.reports);
        break;
      case 5:
        break;
    }
  }

  // Contenido de la página
  Widget _buildConfigurationBody(BuildContext context) {
    final themeManager = context.watch<ThemeManager>();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return ListView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      children: [
        // Perfil de Usuario
        Text(
          'Perfil de Usuario',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Gestiona tu información personal y configuración de cuenta.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(
                        'U',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuario Actual',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'user@example.com',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  initialValue: 'Usuario Demo',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  initialValue: 'user@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  initialValue: '+1234567890',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil actualizado')),
                    );
                  },
                  child: const Text('Actualizar Perfil'),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),
        const Divider(height: 40),

        // Datos del Negocio
        Text(
          'Datos del Negocio',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'Esta información aparecerá en tus recibos y reportes PDF.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),

        // 6. Los TextFormField AHORA USAN los controladores de la clase
        TextFormField(
          controller: _nombreTiendaController,
          decoration: const InputDecoration(
            labelText: 'Nombre de la Tienda',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _direccionController,
          decoration: const InputDecoration(
            labelText: 'Dirección',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _telefonoController,
          decoration: const InputDecoration(
            labelText: 'Teléfono',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _rfcController,
          decoration: const InputDecoration(
            labelText: 'RFC / ID Fiscal',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 30),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Configuración guardada')),
            );
          },
          child: const Text('Guardar Cambios'),
        ),

        const Divider(height: 40),

        Text('Apariencia', style: Theme.of(context).textTheme.headlineSmall),

        SwitchListTile(
          title: const Text('Modo Oscuro'),
          value: themeManager.themeMode == ThemeMode.dark,
          onChanged: (bool value) {
            final newMode = value ? ThemeMode.dark : ThemeMode.light;
            context.read<ThemeManager>().setTheme(newMode);
          },
        ),
      ],
    );
  }
}
