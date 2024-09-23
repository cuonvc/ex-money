import 'package:repository/repository.dart';
import 'package:repository/src/entities/sign_in_entity.dart';

class SignInModel {
  String email;
  String password;

  SignInModel({
    required this.email,
    required this.password
  });

  static SignInModel empty() {
    return SignInModel(email: "", password: "");
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password
    };
  }

  SignInEntity toEntity() {
    return SignInEntity(
        email: email,
        password: password
    );
  }
}