import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/auth_controller.dart';
import 'package:repository/src/utils/http_response.dart';

class UserRepositoryImpl implements UserRepository {

  final authController = AuthController();

  @override
  Future<dynamic> signIn(SignInModel signModel) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await authController.handleSignIn(signModel)).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error cached - ${e.toString()}');
      return HttpResponse.toError(e.toString());
    }
  }
}