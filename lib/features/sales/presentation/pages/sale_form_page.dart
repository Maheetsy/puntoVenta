import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final _formKey = GlobalKey<FormState>();
  DateTime _saleDate = DateTime.now();
  String? _selectedUserId;
  String? _selectedStatus = 'Completada';
  String? _selectedPaymentMethod;
  List<Map<String, dynamic>> _saleItems = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _users = [];
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
      _users = [
        {'id': '1', 'name': 'Usuario 1', 'email': 'user1@example.com'},
        {'id': '2', 'name': 'Usuario 2', 'email': 'user2@example.com'},
        {'id': '3', 'name': 'Usuario 3', 'email': 'user3@example.com'},
      ];
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _saleDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _saleDate) {
      setState(() {
        _saleDate = picked;
      });
    }
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione un usuario'),
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

    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione un estado'),
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
      appBar: AppBar(title: const Text(AppStrings.createSale)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Fecha de venta
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha de Venta',
                            style: AppTextStyles.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Fecha',
                                prefixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                DateFormat('yyyy-MM-dd').format(_saleDate),
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Usuario
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Usuario', style: AppTextStyles.titleMedium),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _selectedUserId,
                            decoration: const InputDecoration(
                              labelText: 'Usuario',
                              prefixIcon: Icon(Icons.person),
                            ),
                            items: _users.map<DropdownMenuItem<String>>((user) {
                              return DropdownMenuItem<String>(
                                value: user['id'] as String,
                                child: Text(
                                  '${user['name']} (${user['email']})',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => _selectedUserId = value);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'El usuario es requerido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Estado
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estado', style: AppTextStyles.titleMedium),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Estado',
                              prefixIcon: Icon(Icons.info),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Completada',
                                child: Text('Completada'),
                              ),
                              DropdownMenuItem(
                                value: 'Pendiente',
                                child: Text('Pendiente'),
                              ),
                              DropdownMenuItem(
                                value: 'Cancelada',
                                child: Text('Cancelada'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => _selectedStatus = value);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'El estado es requerido';
                              }
                              return null;
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
                                        Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 48,
                                          color: AppColors.textSecondary,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No hay productos agregados',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
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
                                        backgroundColor:
                                            AppColors.primaryContainer,
                                        child: Text(
                                          '${index + 1}',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
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
                                            icon: const Icon(
                                              Icons.delete,
                                              color: AppColors.error,
                                            ),
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

                  // Método de pago
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
                              DropdownMenuItem(
                                value: 'Efectivo',
                                child: Text(AppStrings.cash),
                              ),
                              DropdownMenuItem(
                                value: 'Tarjeta',
                                child: Text(AppStrings.card),
                              ),
                              DropdownMenuItem(
                                value: 'Transferencia',
                                child: Text(AppStrings.transfer),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => _selectedPaymentMethod = value);
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'El método de pago es requerido';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Total
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Monto Total', style: AppTextStyles.titleMedium),
                          const SizedBox(height: 12),
                          Text(
                            '\$${_total.toStringAsFixed(2)}',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
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
          ),
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
  State<_ProductSelectionDialog> createState() =>
      _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<_ProductSelectionDialog> {
  String? _selectedProductId;
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );

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
                child: Text(
                  '${product['name'] as String} - \$${(product['price'] as num).toStringAsFixed(2)}',
                ),
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
