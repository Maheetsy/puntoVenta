import '../../domain/entities/user.dart' as entity;

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String role;
  final bool active;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.role = 'vendedor',
    this.active = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      password: '', // Never include password in fromJson
      role: json['role'] as String? ?? 'vendedor',
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson({bool includePassword = true}) {
    final json = {
      if (id != null) '_id': id,
      'name': name,
      'email': email,
      if (includePassword) 'password': password,
      'role': role,
      'active': active,
    };
    return json;
  }

  entity.User toEntity() {
    return entity.User(
      id: id,
      name: name,
      email: email,
      password: password,
      role: role,
      active: active,
    );
  }

  factory UserModel.fromEntity(entity.User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      role: user.role,
      active: user.active,
    );
  }
}

