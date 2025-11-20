class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String role;
  final bool active;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.role = 'vendedor',
    this.active = true,
  });
}

