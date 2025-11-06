import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';

class SaleDetailPage extends StatelessWidget {
  final Map<String, dynamic> sale;

  const SaleDetailPage({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.saleDetail} - ${sale['number']}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Información de la venta
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.saleDetail,
                          style: AppTextStyles.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('Número', sale['number']),
                        _buildInfoRow('Fecha', sale['date']),
                        _buildInfoRow('Cliente', sale['client']),
                        _buildInfoRow('Método de Pago', sale['paymentMethod']),
                        _buildInfoRow('Estado', sale['status']),
                        const Divider(),
                        _buildInfoRow(
                          'Total',
                          '\$${sale['total'].toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Productos de la venta
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.saleItems,
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        // TODO: Mostrar productos reales desde el backend
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
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
                              title: Text('Producto ${index + 1}'),
                              subtitle: Text('Cantidad: ${index + 1} x \$${(index + 1) * 50}.00'),
                              trailing: Text(
                                '\$${((index + 1) * 50 * (index + 1)).toStringAsFixed(2)}',
                                style: AppTextStyles.priceSmall,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.titleMedium
                : AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyles.priceDisplay
                : AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ],
      ),
    );
  }
}

