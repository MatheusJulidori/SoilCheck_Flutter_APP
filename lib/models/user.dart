class User {
  final String username;
  final String password;
  final String name;
  final bool isActive;
  final bool isAdmin;
  final String? id;

  User({
    required this.username,
    required this.password,
    required this.name,
    required this.isAdmin,
    required this.isActive,
    this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      isAdmin: json['isAdmin'],
      isActive: json['isActive'],
      id: json['_id'],
    );
  }
}
