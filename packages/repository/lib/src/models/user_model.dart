import 'package:repository/repository.dart';

class UserModel {
  num id;
  String name;
  String email;
  String password;
  String avatarUrl;
  String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatarUrl,
    required this.role
  });

  UserEntity toEntity() {
    return UserEntity(id: id,
        name: name,
        email: email,
        password: password,
        avatarUrl: avatarUrl,
        role: role
    );
  }
}