class User {
  final String username;
  final String password;
  final bool isActive;
  final bool isAdmin;
  final String? id;

  User({
    required this.username,
    required this.password,
    required this.isAdmin,
    required this.isActive,
    this.id,
  });
}
