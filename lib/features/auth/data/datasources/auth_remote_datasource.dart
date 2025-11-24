import '../../../../core/network/node_api_client.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(String name, String email, String password); // <- AGREGAR ESTA LÍNEA
  Future<UserModel> getMe(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NodeApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        ApiConfig.authLoginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
      );

      // El response debería tener: { success: true, token: "...", user: {...} }
      if (response['success'] == true && response['token'] != null) {
        return {
          'token': response['token'] as String,
          'user': response['user'] as Map<String, dynamic>,
        };
      } else {
        throw ServerException(
          message: response['message']?.toString() ?? 'Error al iniciar sesión',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al iniciar sesión: $e');
    }
  }

  // ========== AGREGAR ESTE MÉTODO COMPLETO ==========
  @override
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await apiClient.post(
        ApiConfig.authRegisterEndpoint, // <- Necesitas agregar este endpoint en ApiConfig
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      // El response debería tener: { success: true, token: "...", user: {...} }
      if (response['success'] == true) {
        return {
          'token': response['token'] as String?,
          'user': response['user'] as Map<String, dynamic>?,
        };
      } else {
        throw ServerException(
          message: response['message']?.toString() ?? 'Error al registrar usuario',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al registrar usuario: $e');
    }
  }
  // ===================================================

  @override
  Future<UserModel> getMe(String token) async {
    try {
      final response = await apiClient.get(
        ApiConfig.authMeEndpoint,
        token: token,
      );

      if (response['success'] == true && response['user'] != null) {
        return UserModel.fromJson(response['user'] as Map<String, dynamic>);
      } else {
        throw ServerException(message: 'Error al obtener información del usuario');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al obtener información del usuario: $e');
    }
  }
}