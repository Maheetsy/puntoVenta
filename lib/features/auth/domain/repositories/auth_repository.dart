import '../entities/user.dart';

abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<User?> getCurrentUser();
}

