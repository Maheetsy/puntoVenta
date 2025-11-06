import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      currentIndex: 0,
      onNavTap: (index) => _navigateToPage(context, index),
      title: AppStrings.dashboardTitle,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final crossAxisCount = isMobile ? 1 : 2;
    final childAspectRatio = isMobile ? 1.5 : 1.2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjetas de resumen
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
            children: [
              _buildStatCard(
                context,
                title: AppStrings.totalSales,
                value: '\$12,450.00',
                icon: Icons.shopping_cart,
                color: AppColors.primary,
              ),
              _buildStatCard(
                context,
                title: AppStrings.totalProducts,
                value: '156',
                icon: Icons.inventory_2,
                color: AppColors.success,
              ),
              _buildStatCard(
                context,
                title: AppStrings.totalClients,
                value: '89',
                icon: Icons.people,
                color: AppColors.info,
              ),
              _buildStatCard(
                context,
                title: AppStrings.lowStock,
                value: '12',
                icon: Icons.warning,
                color: AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Ventas recientes
          Text(
            AppStrings.recentSales,
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 16),
          _buildRecentSales(context),
          
          const SizedBox(height: 24),
          
          // Productos más vendidos
          Text(
            AppStrings.topProducts,
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 16),
          _buildTopProducts(context),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 32, color: color),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.trending_up, size: 16, color: AppColors.success),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSales(BuildContext context) {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: const Icon(Icons.receipt, color: AppColors.primary),
            ),
            title: Text(
              'Venta #${1000 + index}',
              style: AppTextStyles.titleSmall,
            ),
            subtitle: Text(
              'Cliente ${index + 1}',
              style: AppTextStyles.bodySmall,
            ),
            trailing: Text(
              '\$${(index + 1) * 250}.00',
              style: AppTextStyles.priceSmall.copyWith(
                color: AppColors.success,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopProducts(BuildContext context) {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: const Icon(Icons.inventory_2, color: AppColors.primary),
            ),
            title: Text(
              'Producto ${index + 1}',
              style: AppTextStyles.titleSmall,
            ),
            subtitle: Text(
              '${(index + 1) * 10} ventas',
              style: AppTextStyles.bodySmall,
            ),
            trailing: Text(
              '\$${(index + 1) * 50}.00',
              style: AppTextStyles.priceSmall,
            ),
          );
        },
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

