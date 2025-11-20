import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> createUser(User user) async {
    try {
      // Validar datos
      if (user.name.trim().isEmpty) {
        throw ValidationException(message: 'El nombre es requerido');
      }
      if (user.email.trim().isEmpty) {
        throw ValidationException(message: 'El correo es requerido');
      }
      if (user.password.isEmpty || user.password.length < 6) {
        throw ValidationException(message: 'La contraseña debe tener al menos 6 caracteres');
      }

      final model = UserModel.fromEntity(user);
      final created = await remoteDataSource.createUser(model);
      return created.toEntity();
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<List<User>> getUsers() async {
    try {
      final models = await remoteDataSource.getUsers();
      return models.map((model) => model.toEntity()).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<User> getUserById(String userId) async {
    try {
      final model = await remoteDataSource.getUserById(userId);
      return model.toEntity();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<User> updateUser(String userId, User user) async {
    try {
      // Validar datos
      if (user.name.trim().isEmpty) {
        throw ValidationException(message: 'El nombre es requerido');
      }
      if (user.email.trim().isEmpty) {
        throw ValidationException(message: 'El correo es requerido');
      }

      final model = UserModel.fromEntity(user);
      final updated = await remoteDataSource.updateUser(userId, model);
      return updated.toEntity();
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }
}

