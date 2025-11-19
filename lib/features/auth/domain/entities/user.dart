class User {
  final String? id;
  final String name;
  final String email;
  final String? role;

  User({
    this.id,
    required this.name,
    required this.email,
    this.role,
  });
}

