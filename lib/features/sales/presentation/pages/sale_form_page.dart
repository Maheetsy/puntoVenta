import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/animated_snackbar.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../config/di/injection_container.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/sale.dart';

class SaleFormPage extends StatefulWidget {
  const SaleFormPage({super.key});

  @override
  State<SaleFormPage> createState() => _SaleFormPageState();
}

class _SaleFormPageState extends State<SaleFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStatus = 'Completada';
  String? _selectedPaymentMethod;
  List<Map<String, dynamic>> _saleItems = [];
  List<Product> _products = [];
  bool _isLoading = false;
  String? _currentUserId;
  final _saleRepository = injectionContainer.saleRepository;
  final _productRepository = injectionContainer.productRepository;
  final _authRepository = injectionContainer.authRepository;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final products = await _productRepository.getProducts();
      final currentUser = await _authRepository.getCurrentUser();
      setState(() {
        _products = products.where((p) => p.active && p.stock > 0).toList();
        _currentUserId = currentUser?.id;
      });
      if (_currentUserId == null) {
        if (mounted) {
          AnimatedSnackBar.showError(
            context,
            'No se pudo obtener el usuario actual',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AnimatedSnackBar.showError(context, 'Error al cargar datos: $e');
      }
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
              'subtotal': product.price * quantity,
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

    if (_currentUserId == null) {
      AnimatedSnackBar.showError(
        context,
        'No se pudo obtener el usuario actual',
      );
      return;
    }

    if (_selectedPaymentMethod == null) {
      AnimatedSnackBar.showError(
        context,
        'Por favor seleccione un método de pago',
      );
      return;
    }

    if (_selectedStatus == null) {
      AnimatedSnackBar.showError(context, 'Por favor seleccione un estado');
      return;
    }

    if (_saleItems.isEmpty) {
      AnimatedSnackBar.showError(
        context,
        'Por favor agregue al menos un producto',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final saleItems = _saleItems.map((item) {
        final product = item['product'] as Product;
        return SaleItem(
          productId: product.productId!,
          productName: product.name,
          quantity: item['quantity'] as int,
          price: product.price,
          subtotal: item['subtotal'] as double,
        );
      }).toList();

      final sale = Sale(
        saleDate: DateTime.now(), // Fecha actual
        userId: _currentUserId,
        status: _selectedStatus!,
        paymentMethod: _selectedPaymentMethod!,
        items: saleItems,
        total: _total,
      );

      await _saleRepository.createSale(sale);

      if (mounted) {
        AnimatedSnackBar.showSuccess(
          context,
          AppStrings.saleCreated,
          onDismiss: () => Navigator.pop(context, true),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context, true);
        }
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
        AnimatedSnackBar.showError(context, 'Error: $e');
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
                                      title: Text(
                                        (item['product'] as Product).name,
                                      ),
                                      subtitle: Text(
                                        'Cantidad: ${item['quantity']} x \$${(item['product'] as Product).price.toStringAsFixed(2)}',
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
  final List<Product> products;
  final Function(Product, int) onProductSelected;

  const _ProductSelectionDialog({
    required this.products,
    required this.onProductSelected,
  });

  @override
  State<_ProductSelectionDialog> createState() =>
      _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<_ProductSelectionDialog> {
  int? _selectedProductId;
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
          DropdownButtonFormField<int>(
            value: _selectedProductId,
            decoration: const InputDecoration(
              labelText: AppStrings.productName,
              prefixIcon: Icon(Icons.inventory_2),
            ),
            items: widget.products.map<DropdownMenuItem<int>>((product) {
              return DropdownMenuItem<int>(
                value: product.productId,
                child: Text(
                  '${product.name} - \$${product.price.toStringAsFixed(2)} (Stock: ${product.stock})',
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
                (p) => p.productId == _selectedProductId,
              );
              final quantity = int.tryParse(_quantityController.text) ?? 1;
              if (quantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('La cantidad debe ser mayor a 0'),
                  ),
                );
                return;
              }
              if (quantity > product.stock) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'No hay suficiente stock. Disponible: ${product.stock}',
                    ),
                  ),
                );
                return;
              }
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
