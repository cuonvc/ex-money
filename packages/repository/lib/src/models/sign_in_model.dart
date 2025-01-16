import 'package:repository/repository.dart';
import 'package:repository/src/entities/sign_in_entity.dart';

class SignInModel {
  String email;
  String password;
  Object deviceInfo;

  SignInModel({
    required this.email,
    required this.password,
    required this.deviceInfo
  });

  static SignInModel empty() {
    return SignInModel(email: "", password: "", deviceInfo: {});
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'deviceInfo': deviceInfo
    };
  }

  SignInEntity toEntity() {
    return SignInEntity(
        email: email,
        password: password
    );
  }
}