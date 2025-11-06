import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import 'product_form_page.dart';

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    // TODO: Cargar desde el backend
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _products = [
        {
          'id': '1',
          'name': 'Producto 1',
          'description': 'Descripción del producto 1',
          'price': 99.99,
          'stock': 50,
          'category': 'Electrónica',
          'barcode': '1234567890',
        },
        {
          'id': '2',
          'name': 'Producto 2',
          'description': 'Descripción del producto 2',
          'price': 149.99,
          'stock': 30,
          'category': 'Ropa',
          'barcode': '0987654321',
        },
        {
          'id': '3',
          'name': 'Producto 3',
          'description': 'Descripción del producto 3',
          'price': 79.99,
          'stock': 10,
          'category': 'Alimentos',
          'barcode': '1122334455',
        },
      ];
      _filteredProducts = _products;
      _isLoading = false;
    });
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _products.where((product) {
        return product['name'].toString().toLowerCase().contains(query) ||
            product['description'].toString().toLowerCase().contains(query) ||
            product['category'].toString().toLowerCase().contains(query) ||
            product['barcode'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  void _deleteProduct(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.delete),
        content: const Text(AppStrings.deleteProductConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((prod) => prod['id'] == id);
                _filteredProducts = _products;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.productDeleted)),
              );
            },
            child: const Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      currentIndex: 1,
      onNavTap: (index) => _navigateToPage(context, index),
      title: AppStrings.productsTitle,
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
                        _filterProducts();
                      },
                    )
                  : null,
            ),
          ),
        ),

        // Lista de productos
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2, size: 64, color: AppColors.textSecondary),
                          const SizedBox(height: 16),
                          Text(
                            _searchController.text.isEmpty
                                ? AppStrings.noProducts
                                : 'No se encontraron productos',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : isMobile
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return _buildProductCard(context, product, isMobile);
                          },
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return _buildProductCard(context, product, isMobile);
                          },
                        ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product, bool isMobile) {
    final stock = product['stock'] as int;
    final stockColor = stock > 20
        ? AppColors.success
        : stock > 10
            ? AppColors.warning
            : AppColors.error;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToEdit(context, product),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product['category'],
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: const Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text(AppStrings.edit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: AppColors.error),
                            SizedBox(width: 8),
                            Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _navigateToEdit(context, product);
                      } else if (value == 'delete') {
                        _deleteProduct(product['id']);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                product['description'],
                style: AppTextStyles.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product['price'].toStringAsFixed(2)}',
                    style: AppTextStyles.priceCard.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: stockColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Stock: ${product['stock']}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: stockColor,
                        fontWeight: FontWeight.w600,
                      ),
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
        builder: (context) => const ProductFormPage(),
      ),
    ).then((_) => _loadProducts());
  }

  void _navigateToEdit(BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormPage(product: product),
      ),
    ).then((_) => _loadProducts());
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

