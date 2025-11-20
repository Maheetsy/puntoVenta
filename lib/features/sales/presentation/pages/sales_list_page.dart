import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/animated_snackbar.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../config/di/injection_container.dart';
import '../../domain/entities/sale.dart';
import 'sale_form_page.dart';

class SalesListPage extends StatefulWidget {
  const SalesListPage({super.key});

  @override
  State<SalesListPage> createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  final TextEditingController _searchController = TextEditingController();
  final _saleRepository = injectionContainer.saleRepository;
  List<Sale> _sales = [];
  List<Sale> _filteredSales = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSales();
    _searchController.addListener(_filterSales);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSales() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sales = await _saleRepository.getSales();
      setState(() {
        _sales = sales;
        _filteredSales = sales;
        _isLoading = false;
      });
    } on ServerException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
      if (mounted) {
        AnimatedSnackBar.showError(context, e.message);
      }
    } on NetworkException catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión. Verifique su internet.';
        _isLoading = false;
      });
      if (mounted) {
        AnimatedSnackBar.showError(context, e.message);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error inesperado: $e';
        _isLoading = false;
      });
    }
  }

  void _filterSales() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSales = _sales.where((sale) {
        return sale.userName?.toLowerCase().contains(query) ??
            false ||
                sale.saleDate.toString().toLowerCase().contains(query) ||
                sale.status.toLowerCase().contains(query) ||
                sale.total.toString().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      currentIndex: 3,
      onNavTap: (index) => _navigateToPage(context, index),
      title: AppStrings.salesTitle,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreate(context),
        child: const Icon(Icons.add),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      children: [
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppStrings.search,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterSales();
                      },
                    )
                  : null,
            ),
          ),
        ),

        // Lista de ventas
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSales,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _filteredSales.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? AppStrings.noSales
                            : 'No se encontraron ventas',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredSales.length,
                  itemBuilder: (context, index) {
                    final sale = _filteredSales[index];
                    return _buildSaleCard(context, sale, isMobile);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSaleCard(BuildContext context, Sale sale, bool isMobile) {
    final status = sale.status;
    final statusColor = status == 'Completada'
        ? AppColors.success
        : status == 'Pendiente'
        ? AppColors.warning
        : AppColors.error;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToDetail(context, sale),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sale.saleId != null
                              ? 'V-${sale.saleId!.substring(0, sale.saleId!.length > 8 ? 8 : sale.saleId!.length).toUpperCase()}'
                              : 'V-N/A',
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sale.userName ?? 'Usuario no disponible',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: AppColors.primary,
                        onPressed: () {
                          // TODO: Implementar editar venta
                        },
                        tooltip: AppStrings.edit,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: AppColors.error,
                        onPressed: () {
                          // TODO: Implementar eliminar venta
                        },
                        tooltip: AppStrings.delete,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha: ${sale.saleDate.toLocal().toString().split(' ')[0]}',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Método: ${sale.paymentMethod}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  Text(
                    '\$${sale.total.toStringAsFixed(2)}',
                    style: AppTextStyles.priceCard.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCreate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SaleFormPage()),
    ).then((_) => _loadSales());
  }

  void _navigateToDetail(BuildContext context, Sale sale) {
    // TODO: Implementar página de detalle de venta
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SaleDetailPage(sale: sale),
    //   ),
    // );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.products);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.categories);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.sales);
        break;
      case 4:
        Navigator.pushReplacementNamed(context, AppRoutes.users);
        break;
      case 5:
        Navigator.pushReplacementNamed(context, AppRoutes.reports);
        break;
      case 6:
        Navigator.pushReplacementNamed(context, AppRoutes.settings);
        break;
    }
  }
}
