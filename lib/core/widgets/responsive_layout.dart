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
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return Scaffold(
        appBar: title != null
            ? AppBar(
                title: Text(title!),
                actions: actions,
              )
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
            ? AppBar(
                title: Text(title!),
                actions: actions,
              )
            : null,
        drawer: ResponsiveNavbar(
          currentIndex: currentIndex,
          onTap: onNavTap,
        ),
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      );
    }
  }
}

