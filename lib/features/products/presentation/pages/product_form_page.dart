import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ProductFormPage extends StatefulWidget {
  final Map<String, dynamic>? product;

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
  String? _selectedCategory;
  bool _isLoading = false;
  bool _isActive = true;
  List<String> _categories = ['Electrónica', 'Ropa', 'Alimentos'];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['name'] ?? '';
      _descriptionController.text = widget.product!['description'] ?? '';
      _priceController.text = widget.product!['price']?.toString() ?? '';
      _stockController.text = widget.product!['stock']?.toString() ?? '';
      _imageUrlController.text = widget.product!['image_url'] ?? '';
      _selectedCategory = widget.product!['category'];
      _isActive = widget.product!['active'] ?? true;
    } else {
      // Valor inicial en 0 para productos nuevos
      _priceController.text = '0';
      _stockController.text = '0';
      _isActive = true;
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

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor seleccione una categoría'),
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
            content: Text(
              widget.product == null
                  ? AppStrings.productCreated
                  : AppStrings.productUpdated,
            ),
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
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: AppStrings.productCategory,
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value);
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
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) => Validators.positiveNumber(value, 'Precio'),
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: AppStrings.productStock,
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          validator: (value) => Validators.positiveInteger(value, 'Stock'),
                          prefixIcon: const Icon(Icons.inventory),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Producto Activo'),
                    subtitle: Text(_isActive ? 'El producto está activo' : 'El producto está desactivado'),
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

