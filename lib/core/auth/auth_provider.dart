import 'package:flutter/material.dart';

enum UserRole { admin, gerente, vendedor }

enum AppPermission {
  viewDashboard,
  viewProducts,
  manageProducts,
  restockProducts,
  viewCategories,
  manageCategories,
  viewSales,
  manageSales,
  manageUsers,
  viewReports,
  manageProfile,
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

class AuthProvider extends ChangeNotifier {
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  UserRole get role => _currentUser?.role ?? UserRole.vendedor;

  void login(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  bool hasPermission(AppPermission permission) {
    final currentRole = role;

    switch (permission) {
      case AppPermission.viewDashboard:
      case AppPermission.viewProducts:
      case AppPermission.viewCategories:
      case AppPermission.viewSales:
      case AppPermission.manageProfile:
        return true;
      case AppPermission.restockProducts:
        return currentRole != UserRole.vendedor ? true : false;
      case AppPermission.manageSales:
        return true;
      case AppPermission.manageProducts:
      case AppPermission.manageCategories:
      case AppPermission.manageUsers:
      case AppPermission.viewReports:
        return currentRole == UserRole.admin || currentRole == UserRole.gerente;
    }
  }

  void setRole(UserRole role) {
    final user = _currentUser;
    if (user == null) return;
    _currentUser = AppUser(
      id: user.id,
      name: user.name,
      email: user.email,
      role: role,
    );
    notifyListeners();
  }
}

