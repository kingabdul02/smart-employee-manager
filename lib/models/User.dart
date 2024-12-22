class User {
  final int id;
  final String name;
  final String email;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isActive: json['is_active'] == 1,
    );
  }
}
