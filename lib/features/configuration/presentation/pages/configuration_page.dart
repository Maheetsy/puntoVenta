import 'package:flutter/material.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/animated_snackbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/services/company_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../config/di/injection_container.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../auth/domain/entities/user.dart' as auth_entity;
import '../../../users/domain/entities/user.dart' as user_entity;

// 1. Convertimos a StatefulWidget
class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  // Controladores para perfil de usuario
  late final TextEditingController _userNameController;
  late final TextEditingController _userEmailController;
  late final TextEditingController _userPhoneController;

  // Controladores para datos de empresa
  late final TextEditingController _nombreTiendaController;
  late final TextEditingController _direccionController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _rfcController;

  final _authRepository = injectionContainer.authRepository;
  final _userRepository = injectionContainer.userRepository;
  auth_entity.User? _currentUser;
  bool _isLoadingUser = true;
  bool _isSavingUser = false;
  bool _isSavingCompany = false;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _userEmailController = TextEditingController();
    _userPhoneController = TextEditingController();
    _nombreTiendaController = TextEditingController();
    _direccionController = TextEditingController();
    _telefonoController = TextEditingController();
    _rfcController = TextEditingController();
    _loadUserData();
    _loadCompanyData();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
    _nombreTiendaController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoadingUser = true;
    });
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        setState(() {
          _currentUser = user;
          _userNameController.text = user.name;
          _userEmailController.text = user.email;
          _userPhoneController.text = '';
          _isLoadingUser = false;
        });
      } else {
        setState(() {
          _isLoadingUser = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingUser = false;
      });
      if (mounted) {
        AnimatedSnackBar.showError(
          context,
          'Error al cargar datos del usuario: $e',
        );
      }
    }
  }

  Future<void> _loadCompanyData() async {
    try {
      final companyData = await CompanyService.getCompanyData();
      setState(() {
        _nombreTiendaController.text = companyData['nombreTienda'] ?? '';
        _direccionController.text = companyData['direccion'] ?? '';
        _telefonoController.text = companyData['telefono'] ?? '';
        _rfcController.text = companyData['rfc'] ?? '';
      });
    } catch (e) {
      if (mounted) {
        AnimatedSnackBar.showError(
          context,
          'Error al cargar datos de la empresa: $e',
        );
      }
    }
  }

  Future<void> _saveUserProfile() async {
    if (_currentUser == null || _currentUser!.id == null) {
      AnimatedSnackBar.showError(
        context,
        'No se pudo obtener el usuario actual',
      );
      return;
    }

    setState(() {
      _isSavingUser = true;
    });

    try {
      final updatedUser = user_entity.User(
        id: _currentUser!.id,
        name: _userNameController.text.trim(),
        email: _userEmailController.text.trim(),
        password: '', // No se actualiza la contraseña aquí
        role: _currentUser!.role ?? 'vendedor',
        active: true, // Mantener activo por defecto
      );

      await _userRepository.updateUser(_currentUser!.id!, updatedUser);

      // Recargar datos del usuario
      await _loadUserData();

      if (mounted) {
        AnimatedSnackBar.showSuccess(
          context,
          'Perfil actualizado exitosamente',
        );
      }
    } on ValidationException catch (e) {
      if (mounted) {
        AnimatedSnackBar.showError(context, e.message);
      }
    } on ServerException catch (e) {
      if (mounted) {
        AnimatedSnackBar.showError(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        AnimatedSnackBar.showError(context, 'Error al actualizar perfil: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingUser = false;
        });
      }
    }
  }

  Future<void> _saveCompanyData() async {
    setState(() {
      _isSavingCompany = true;
    });

    try {
      await CompanyService.saveCompanyData(
        nombreTienda: _nombreTiendaController.text.trim(),
        direccion: _direccionController.text.trim(),
        telefono: _telefonoController.text.trim(),
        rfc: _rfcController.text.trim(),
      );

      if (mounted) {
        AnimatedSnackBar.showSuccess(
          context,
          'Datos de la empresa guardados exitosamente',
        );
      }
    } catch (e) {
      if (mounted) {
        AnimatedSnackBar.showError(context, 'Error al guardar datos: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingCompany = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 5. El 'build' ahora usa los controladores que ya existen
    return ResponsiveLayout(
      currentIndex: 6,
      onNavTap: (index) => _navigateToPage(context, index),
      title: 'Configuración',
      body: _buildConfigurationBody(context),
    );
  }

  // Lógica de navegación
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
        if (currentRoute != AppRoutes.users)
          Navigator.pushReplacementNamed(context, AppRoutes.users);
        break;
      case 5:
        if (currentRoute != AppRoutes.reports)
          Navigator.pushReplacementNamed(context, AppRoutes.reports);
        break;
      case 6:
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
                _isLoadingUser
                    ? const Center(child: CircularProgressIndicator())
                    : _currentUser == null
                    ? const Text('No se pudo cargar el usuario')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColors.primaryContainer,
                                child: Text(
                                  _currentUser!.name.isNotEmpty
                                      ? _currentUser!.name[0].toUpperCase()
                                      : 'U',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: AppColors.primary),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _currentUser!.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentUser!.email,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _currentUser!.role ?? 'vendedor',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          CustomTextField(
                            label: 'Nombre Completo',
                            controller: _userNameController,
                            prefixIcon: const Icon(Icons.person),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Correo Electrónico',
                            controller: _userEmailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Teléfono',
                            controller: _userPhoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Actualizar Perfil',
                            onPressed: _isSavingUser ? null : _saveUserProfile,
                            isLoading: _isSavingUser,
                            icon: Icons.save,
                          ),
                        ],
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

        CustomTextField(
          label: 'Nombre de la Tienda',
          controller: _nombreTiendaController,
          prefixIcon: const Icon(Icons.store),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Dirección',
          controller: _direccionController,
          prefixIcon: const Icon(Icons.location_on),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Teléfono',
          controller: _telefonoController,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.phone),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'RFC / ID Fiscal',
          controller: _rfcController,
          prefixIcon: const Icon(Icons.description),
        ),
        const SizedBox(height: 30),

        CustomButton(
          text: 'Guardar Datos de la Empresa',
          onPressed: _isSavingCompany ? null : _saveCompanyData,
          isLoading: _isSavingCompany,
          icon: Icons.save,
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
