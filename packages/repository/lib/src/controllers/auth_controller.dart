import 'dart:convert';

import 'package:repository/repository.dart';
import 'package:http/http.dart' as http;

import '../utils/constant.dart';

class AuthController {
  Future<dynamic> handleSignIn(SignInModel signInModel) async {
    return http.post(
        Uri.parse('$domain/api/auth/sign-in'),
        headers: {
          'Accept-Language': 'vi', //required
          'Content-Type': 'application/json'
        },
        body: jsonEncode(signInModel.toMap())
    );
  }
}