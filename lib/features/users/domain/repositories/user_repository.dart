import '../entities/user.dart';

abstract class UserRepository {
  Future<User> createUser(User user);
  Future<List<User>> getUsers();
  Future<User> getUserById(String userId);
  Future<User> updateUser(String userId, User user);
}

