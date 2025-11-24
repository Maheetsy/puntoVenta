import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> login(String email, String password) async {
    try {
      // Validar datos
      if (email.trim().isEmpty) {
        throw ValidationException(message: 'El email es requerido');
      }
      if (password.isEmpty) {
        throw ValidationException(message: 'La contraseña es requerida');
      }

      final result = await remoteDataSource.login(email.trim(), password);

      // Guardar token usando AuthService
      if (result['token'] != null) {
        await AuthService.saveToken(result['token']);
      }

    } catch (e) {
      if (e is ValidationException) {
        rethrow;
      }
      throw ServerException(message: 'Error al iniciar sesión');
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      // Validar datos
      if (email.trim().isEmpty) {
        throw ValidationException(message: 'El email es requerido');
      }
      if (password.isEmpty) {
        throw ValidationException(message: 'La contraseña es requerida');
      }
      if (name.trim().isEmpty) {
        throw ValidationException(message: 'El nombre es requerido');
      }

      final result = await remoteDataSource.register(name.trim(), email.trim(), password);

      // Guardar token si lo devuelve (usando AuthService)
      if (result['token'] != null) {
        await AuthService.saveToken(result['token']);
      }

    } catch (e) {
      if (e is ValidationException) {
        rethrow;
      }
      throw ServerException(message: 'Error al registrar usuario');
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
  Future<String?> getToken() async {
    return await AuthService.getToken();
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