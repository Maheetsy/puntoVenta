import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import 'sale_form_page.dart';
import 'sale_detail_page.dart';

class SalesListPage extends StatefulWidget {
  const SalesListPage({super.key});

  @override
  State<SalesListPage> createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _sales = [];
  List<Map<String, dynamic>> _filteredSales = [];
  bool _isLoading = true;

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
    setState(() => _isLoading = true);
    // TODO: Cargar desde el backend
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _sales = [
        {
          'id': '1',
          'number': 'V-001',
          'date': '2024-01-15',
          'client': 'Juan Pérez',
          'total': 299.99,
          'status': 'Completada',
          'paymentMethod': 'Efectivo',
        },
        {
          'id': '2',
          'number': 'V-002',
          'date': '2024-01-16',
          'client': 'María García',
          'total': 449.99,
          'status': 'Completada',
          'paymentMethod': 'Tarjeta',
        },
        {
          'id': '3',
          'number': 'V-003',
          'date': '2024-01-17',
          'client': 'Carlos López',
          'total': 179.99,
          'status': 'Pendiente',
          'paymentMethod': 'Transferencia',
        },
      ];
      _filteredSales = _sales;
      _isLoading = false;
    });
  }

  void _filterSales() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSales = _sales.where((sale) {
        return sale['number'].toString().toLowerCase().contains(query) ||
            sale['client'].toString().toLowerCase().contains(query) ||
            sale['date'].toString().toLowerCase().contains(query);
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
              : _filteredSales.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart, size: 64, color: AppColors.textSecondary),
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

  Widget _buildSaleCard(BuildContext context, Map<String, dynamic> sale, bool isMobile) {
    final status = sale['status'] as String;
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
                          sale['number'],
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sale['client'],
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                        'Fecha: ${sale['date']}',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Método: ${sale['paymentMethod']}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  Text(
                    '\$${sale['total'].toStringAsFixed(2)}',
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
      MaterialPageRoute(
        builder: (context) => const SaleFormPage(),
      ),
    ).then((_) => _loadSales());
  }

  void _navigateToDetail(BuildContext context, Map<String, dynamic> sale) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaleDetailPage(sale: sale),
      ),
    );
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
        Navigator.pushReplacementNamed(context, AppRoutes.clients);
        break;
    }
  }
}

