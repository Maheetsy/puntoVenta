import 'package:flutter/material.dart';
import 'responsive_navbar.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final Function(int) onNavTap;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const ResponsiveLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onNavTap,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isWeb = width >= 1200;
    final maxWidth = isWeb ? 1200.0 : (width < 768 ? width : 800.0);

    final iconActions = <Widget>[];
    if (actions != null) {
      iconActions.addAll(actions!);
    }
    // Agregar icono en la esquina superior derecha
    try {
      iconActions.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Image.asset(
            'assets/images/icono.png',
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    } catch (e) {
      // Si no existe la imagen, no mostrar nada
    }

    if (isMobile) {
      return Scaffold(
        appBar: title != null
            ? AppBar(title: Text(title!), actions: iconActions)
            : null,
        body: body,
        bottomNavigationBar: ResponsiveNavbar(
          currentIndex: currentIndex,
          onTap: onNavTap,
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      );
    } else {
      return Scaffold(
        appBar: title != null
            ? AppBar(title: Text(title!), actions: iconActions)
            : null,
        drawer: ResponsiveNavbar(currentIndex: currentIndex, onTap: onNavTap),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: body,
          ),
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      );
    }
  }
}
