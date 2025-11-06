import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

class SaleFormPage extends StatefulWidget {
  const SaleFormPage({super.key});

  @override
  State<SaleFormPage> createState() => _SaleFormPageState();
}

class _SaleFormPageState extends State<SaleFormPage> {
  String? _selectedClient;
  String? _selectedPaymentMethod;
  List<Map<String, dynamic>> _saleItems = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _clients = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // TODO: Cargar desde el backend
    setState(() {
      _products = [
        {'id': '1', 'name': 'Producto 1', 'price': 99.99, 'stock': 50},
        {'id': '2', 'name': 'Producto 2', 'price': 149.99, 'stock': 30},
        {'id': '3', 'name': 'Producto 3', 'price': 79.99, 'stock': 10},
      ];
      _clients = [
        {'id': '1', 'name': 'Juan Pérez'},
        {'id': '2', 'name': 'María García'},
        {'id': '3', 'name': 'Carlos López'},
      ];
    });
  }

  void _addProduct() {
    showDialog(
      context: context,
      builder: (context) => _ProductSelectionDialog(
        products: _products,
        onProductSelected: (product, quantity) {
          setState(() {
            _saleItems.add({
              'product': product,
              'quantity': quantity,
              'subtotal': product['price'] * quantity,
            });
          });
        },
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      _saleItems.removeAt(index);
    });
  }

  double get _total {
    return _saleItems.fold(0.0, (sum, item) => sum + item['subtotal']);
  }

  Future<void> _saveSale() async {
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione un cliente'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione un método de pago'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_saleItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor agregue al menos un producto'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Guardar en el backend
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.saleCreated),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.errorGeneric),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createSale),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selección de cliente
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.saleClient,
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedClient,
                      decoration: const InputDecoration(
                        labelText: 'Cliente',
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: _clients.map<DropdownMenuItem<String>>((client) {
                        return DropdownMenuItem<String>(
                          value: client['id'] as String,
                          child: Text(client['name'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedClient = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Productos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.saleItems,
                          style: AppTextStyles.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addProduct,
                          tooltip: AppStrings.addProduct,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _saleItems.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(Icons.shopping_cart_outlined,
                                      size: 48, color: AppColors.textSecondary),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No hay productos agregados',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _saleItems.length,
                            itemBuilder: (context, index) {
                              final item = _saleItems[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primaryContainer,
                                  child: Text(
                                    '${index + 1}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                title: Text(item['product']['name']),
                                subtitle: Text(
                                  'Cantidad: ${item['quantity']} x \$${item['product']['price'].toStringAsFixed(2)}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '\$${item['subtotal'].toStringAsFixed(2)}',
                                      style: AppTextStyles.priceSmall,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: AppColors.error),
                                      onPressed: () => _removeItem(index),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Método de pago y total
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.paymentMethod,
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMethod,
                      decoration: const InputDecoration(
                        labelText: 'Método de Pago',
                        prefixIcon: Icon(Icons.payment),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'cash', child: Text(AppStrings.cash)),
                        DropdownMenuItem(value: 'card', child: Text(AppStrings.card)),
                        DropdownMenuItem(value: 'transfer', child: Text(AppStrings.transfer)),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedPaymentMethod = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppColors.divider),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.total,
                          style: AppTextStyles.headlineSmall,
                        ),
                        Text(
                          '\$${_total.toStringAsFixed(2)}',
                          style: AppTextStyles.priceDisplay,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botón guardar
            CustomButton(
              text: AppStrings.save,
              onPressed: _saveSale,
              isLoading: _isLoading,
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductSelectionDialog extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>, int) onProductSelected;

  const _ProductSelectionDialog({
    required this.products,
    required this.onProductSelected,
  });

  @override
  State<_ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<_ProductSelectionDialog> {
  String? _selectedProductId;
  final TextEditingController _quantityController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.addProduct),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedProductId,
            decoration: const InputDecoration(
              labelText: AppStrings.productName,
              prefixIcon: Icon(Icons.inventory_2),
            ),
            items: widget.products.map<DropdownMenuItem<String>>((product) {
              return DropdownMenuItem<String>(
                value: product['id'] as String,
                child: Text('${product['name'] as String} - \$${(product['price'] as num).toStringAsFixed(2)}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedProductId = value);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: AppStrings.quantity,
              prefixIcon: Icon(Icons.numbers),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedProductId != null) {
              final product = widget.products.firstWhere(
                (p) => p['id'] == _selectedProductId,
              );
              final quantity = int.tryParse(_quantityController.text) ?? 1;
              widget.onProductSelected(product, quantity);
              Navigator.pop(context);
            }
          },
          child: const Text(AppStrings.addProduct),
        ),
      ],
    );
  }
}

