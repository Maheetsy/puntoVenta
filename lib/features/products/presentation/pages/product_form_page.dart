import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/animated_snackbar.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../config/di/injection_container.dart';
import '../../domain/entities/product.dart';
import '../../../categories/domain/entities/category.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _productRepository = injectionContainer.productRepository;
  final _categoryRepository = injectionContainer.categoryRepository;
  int? _selectedCategoryId;
  bool _isLoading = false;
  bool _isLoadingCategories = true;
  bool _isActive = true;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _imageUrlController.text = widget.product!.imagenUrl ?? '';
      _selectedCategoryId = widget.product!.categoryId;
      _isActive = widget.product!.active;
    } else {
      // Valor inicial en 0 para productos nuevos
      _priceController.text = '0';
      _stockController.text = '0';
      _isActive = true;
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });
    try {
      final categories = await _categoryRepository.getCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
        // Si estamos editando y tenemos un producto con categoría, asegurar que esté seleccionada
        if (widget.product != null && _selectedCategoryId != null) {
          // Verificar que la categoría seleccionada exista en la lista cargada
          final categoryExists = categories.any(
            (cat) => cat.categoryId == _selectedCategoryId,
          );
          if (!categoryExists && categories.isNotEmpty) {
            // Si la categoría no existe, seleccionar la primera disponible
            _selectedCategoryId = categories.first.categoryId;
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      if (mounted) {
        AnimatedSnackBar.showError(context, 'Error al cargar categorías: $e');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == null) {
      AnimatedSnackBar.showError(context, 'Por favor seleccione una categoría');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final stock = int.tryParse(_stockController.text) ?? 0;

      final product = Product(
        productId: widget.product?.productId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        price: price,
        stock: stock,
        imagenUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        active: _isActive,
        categoryId: _selectedCategoryId!,
      );

      if (widget.product == null) {
        await _productRepository.createProduct(product);
      } else {
        await _productRepository.updateProduct(
          widget.product!.productId!,
          product,
        );
      }

      if (mounted) {
        AnimatedSnackBar.showSuccess(
          context,
          widget.product == null
              ? AppStrings.productCreated
              : AppStrings.productUpdated,
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
      appBar: AppBar(
        title: Text(
          widget.product == null
              ? AppStrings.createProduct
              : AppStrings.editProduct,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    label: AppStrings.productName,
                    controller: _nameController,
                    validator: (value) => Validators.required(value, 'Nombre'),
                    prefixIcon: const Icon(Icons.inventory_2),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppStrings.productDescription,
                    controller: _descriptionController,
                    maxLines: 4,
                    prefixIcon: const Icon(Icons.description),
                  ),
                  const SizedBox(height: 16),
                  _isLoadingCategories
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<int>(
                          value: _selectedCategoryId,
                          decoration: InputDecoration(
                            labelText: AppStrings.productCategory,
                            prefixIcon: const Icon(Icons.category),
                          ),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category.categoryId,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedCategoryId = value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'La categoría es requerida';
                            }
                            return null;
                          },
                        ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppStrings.productImage,
                    controller: _imageUrlController,
                    prefixIcon: const Icon(Icons.image),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final uri = Uri.tryParse(value);
                        if (uri == null || !uri.hasAbsolutePath) {
                          return 'Ingrese una URL válida';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: AppStrings.productPrice,
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) =>
                              Validators.positiveNumber(value, 'Precio'),
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Producto Activo'),
                    subtitle: Text(
                      _isActive
                          ? 'El producto está activo'
                          : 'El producto está desactivado',
                    ),
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: AppStrings.save,
                    onPressed: _saveProduct,
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
