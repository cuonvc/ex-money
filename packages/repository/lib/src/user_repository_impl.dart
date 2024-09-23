import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/auth_controller.dart';
import 'package:repository/src/utils/http_response.dart';

class UserRepositoryImpl implements UserRepository {

  final authController = AuthController();

  @override
  Future<void> signIn(SignInModel signModel) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await authController.handleSignIn(signModel)).bodyBytes));
      HttpResponse response = HttpResponse.toObject(mapResponse);

      if(response.code == 0) {
        log("Login success");
      } else {
        log("Login failed");
      }
    } catch (e) {
      log('Error cached - ${e.toString()}');
      rethrow;
    }
  }
}