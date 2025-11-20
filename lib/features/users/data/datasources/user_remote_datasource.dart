import '../../../../core/network/node_api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/auth_service.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> createUser(UserModel user);
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(String userId);
  Future<UserModel> updateUser(String userId, UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final NodeApiClient apiClient;

  UserRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final token = await _getToken();
      final response = await apiClient.post(
        '/api/users/register',
        body: user.toJson(includePassword: true),
        token: token,
      );

      if (response['success'] == true && response['user'] != null) {
        return UserModel.fromJson(response['user'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response['message']?.toString() ?? 'Error al crear usuario',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al crear usuario: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final token = await _getToken();
      final response = await apiClient.get(
        '/api/users',
        token: token,
      );

      if (response['success'] == true && response['users'] != null) {
        final users = response['users'] as List;
        return users.map((user) => UserModel.fromJson(user as Map<String, dynamic>)).toList();
      } else {
        throw ServerException(
          message: response['message']?.toString() ?? 'Error al obtener usuarios',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al obtener usuarios: $e');
    }
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final token = await _getToken();
      final response = await apiClient.get(
        '/api/users/$userId',
        token: token,
      );

      if (response['success'] == true && response['user'] != null) {
        return UserModel.fromJson(response['user'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response['message']?.toString() ?? 'Error al obtener usuario',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al obtener usuario: $e');
    }
  }

  @override
  Future<UserModel> updateUser(String userId, UserModel user) async {
    try {
      final token = await _getToken();
      final response = await apiClient.put(
        '/api/users/$userId',
        body: {
          'name': user.name,
          'email': user.email,
          'role': user.role,
          'active': user.active,
        },
        token: token,
      );

      if (response['success'] == true && response['user'] != null) {
        return UserModel.fromJson(response['user'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response['message']?.toString() ?? 'Error al actualizar usuario',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al actualizar usuario: $e');
    }
  }

  Future<String?> _getToken() async {
    return await AuthService.getToken();
  }
}

