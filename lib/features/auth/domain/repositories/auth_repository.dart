import '../entities/user.dart';

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String name, String email, String password);
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<String?> getToken();
  Future<User?> getCurrentUser();
}