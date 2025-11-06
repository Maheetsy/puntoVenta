import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ClientFormPage extends StatefulWidget {
  final Map<String, dynamic>? client;

  const ClientFormPage({super.key, this.client});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _nameController.text = widget.client!['name'] ?? '';
      _emailController.text = widget.client!['email'] ?? '';
      _phoneController.text = widget.client!['phone'] ?? '';
      _addressController.text = widget.client!['address'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) {
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
              widget.client == null
                  ? AppStrings.clientCreated
                  : AppStrings.clientUpdated,
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
          widget.client == null
              ? AppStrings.createClient
              : AppStrings.editClient,
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
                    label: AppStrings.clientName,
                    controller: _nameController,
                    validator: (value) => Validators.required(value, 'Nombre'),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppStrings.clientEmail,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppStrings.clientPhone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: AppStrings.clientAddress,
                    controller: _addressController,
                    maxLines: 3,
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: AppStrings.save,
                    onPressed: _saveClient,
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

