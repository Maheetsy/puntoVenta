import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../theme/text_styles.dart';

class ResponsiveNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ResponsiveNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return _buildMobileNavbar(context);
    } else {
      return _buildDesktopNavbar(context);
    }
  }

  Widget _buildMobileNavbar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: Colors.white,
      elevation: 8,
      selectedLabelStyle: AppTextStyles.labelSmall,
      unselectedLabelStyle: AppTextStyles.labelSmall,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: AppStrings.navDashboard,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2),
          label: AppStrings.navProducts,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: AppStrings.navCategories,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: AppStrings.navSales,
        ),
      ],
    );
  }

  Widget _buildDesktopNavbar(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/icono.png',
                  width: 90,
                  height: 90,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.point_of_sale,
                      size: 90,
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildNavItem(
            context,
            icon: Icons.dashboard,
            title: AppStrings.navDashboard,
            route: AppRoutes.dashboard,
            index: 0,
          ),
          _buildNavItem(
            context,
            icon: Icons.inventory_2,
            title: AppStrings.navProducts,
            route: AppRoutes.products,
            index: 1,
          ),
          _buildNavItem(
            context,
            icon: Icons.category,
            title: AppStrings.navCategories,
            route: AppRoutes.categories,
            index: 2,
          ),
          _buildNavItem(
            context,
            icon: Icons.shopping_cart,
            title: AppStrings.navSales,
            route: AppRoutes.sales,
            index: 3,
          ),
          const Divider(),
          _buildNavItem(
            context,
            icon: Icons.people,
            title: AppStrings.navUsers,
            route: AppRoutes.users,
            index: 4,
          ),
          _buildNavItem(
            context,
            icon: Icons.assessment,
            title: AppStrings.navReports,
            route: AppRoutes.reports,
            index: 5,
          ),
          _buildNavItem(
            context,
            icon: Icons.settings,
            title: AppStrings.navSettings,
            route: AppRoutes.settings,
            index: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primaryContainer,
      onTap: () {
        Navigator.pop(context);
        onTap(index);
      },
    );
  }
}
