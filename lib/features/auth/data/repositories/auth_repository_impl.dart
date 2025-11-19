import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> login(String email, String password) async {
    try {
      // Validar datos
      if (email.trim().isEmpty) {
        throw ValidationException(message: 'El email es requerido');
      }
      if (password.isEmpty) {
        throw ValidationException(message: 'La contraseña es requerida');
      }

      final result = await remoteDataSource.login(email.trim(), password);
      final token = result['token'] as String;

      // Guardar token
      await AuthService.saveToken(token);

      return token;
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<void> logout() async {
    await AuthService.deleteToken();
  }

  @override
  Future<bool> isAuthenticated() async {
    return await AuthService.isAuthenticated();
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      final userModel = await remoteDataSource.getMe(token);
      return User(
        id: userModel.id,
        name: userModel.name,
        email: userModel.email,
        role: userModel.role,
      );
    } catch (e) {
      return null;
    }
  }
}

