import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

          // Gráfica de ventas
          if (!isMobile)
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ventas del Mes',
                            style: AppTextStyles.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: [
                                      const FlSpot(0, 2),
                                      const FlSpot(1, 3.5),
                                      const FlSpot(2, 2.5),
                                      const FlSpot(3, 4),
                                      const FlSpot(4, 3),
                                      const FlSpot(5, 5),
                                      const FlSpot(6, 4.5),
                                    ],
                                    isCurved: true,
                                    color: AppColors.primary,
                                    barWidth: 3,
                                    dotData: FlDotData(show: true),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: AppColors.primary.withOpacity(0.1),
                                    ),
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
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ventas por Categoría',
                            style: AppTextStyles.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: 35,
                                    title: '35%',
                                    color: AppColors.primary,
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    value: 25,
                                    title: '25%',
                                    color: AppColors.success,
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    value: 20,
                                    title: '20%',
                                    color: AppColors.warning,
                                    radius: 60,
                                  ),
                                  PieChartSectionData(
                                    value: 20,
                                    title: '20%',
                                    color: AppColors.info,
                                    radius: 60,
                                  ),
                                ],
                                sectionsSpace: 2,
                                centerSpaceRadius: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          if (!isMobile) const SizedBox(height: 24),

          // Gráfica de barras de ventas semanales
          if (!isMobile)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ventas Semanales', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 10,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = [
                                    'Lun',
                                    'Mar',
                                    'Mié',
                                    'Jue',
                                    'Vie',
                                    'Sáb',
                                    'Dom',
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < days.length) {
                                    return Text(
                                      days[value.toInt()],
                                      style: AppTextStyles.bodySmall,
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: 6,
                                  color: AppColors.primary,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: 8,
                                  color: AppColors.primary,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: 5,
                                  color: AppColors.primary,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(
                                  toY: 7,
                                  color: AppColors.primary,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 4,
                              barRods: [
                                BarChartRodData(
                                  toY: 9,
                                  color: AppColors.primary,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 5,
                              barRods: [
                                BarChartRodData(
                                  toY: 8,
                                  color: AppColors.primary,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 6,
                              barRods: [
                                BarChartRodData(
                                  toY: 7,
                                  color: AppColors.primary,
                                  width: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (!isMobile) const SizedBox(height: 24),

          // Ventas recientes
          Text(AppStrings.recentSales, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          _buildRecentSales(context),

          const SizedBox(height: 24),

          // Productos más vendidos
          Text(AppStrings.topProducts, style: AppTextStyles.headlineMedium),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    size: 16,
                    color: AppColors.success,
                  ),
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

  // --- ⬇️ AQUÍ ESTÁ LA FUNCIÓN ACTUALIZADA ⬇️ ---
  void _navigateToPage(BuildContext context, int index) {
    // Obtenemos la ruta actual para no recargar la misma página
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (index) {
      case 0:
        if (currentRoute != AppRoutes.dashboard) {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
        break;
      case 1:
        if (currentRoute != AppRoutes.products) {
          Navigator.pushReplacementNamed(context, AppRoutes.products);
        }
        break;
      case 2:
        if (currentRoute != AppRoutes.categories) {
          Navigator.pushReplacementNamed(context, AppRoutes.categories);
        }
        break;
      case 3:
        if (currentRoute != AppRoutes.sales) {
          Navigator.pushReplacementNamed(context, AppRoutes.sales);
        }
        break;
      case 4:
        if (currentRoute != AppRoutes.users) {
          Navigator.pushReplacementNamed(context, AppRoutes.users);
        }
        break;
      case 5:
        if (currentRoute != AppRoutes.reports) {
          Navigator.pushReplacementNamed(context, AppRoutes.reports);
        }
        break;
      case 6:
        if (currentRoute != AppRoutes.settings) {
          Navigator.pushReplacementNamed(context, AppRoutes.settings);
        }
        break;
      // ----------------------------------------
    }
  }
}
