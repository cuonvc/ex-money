class UserEntity {
  String id;
  String name;
  String email;
  String password;
  String avatarUrl;
  String role;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatarUrl,
    required this.role
  });
}