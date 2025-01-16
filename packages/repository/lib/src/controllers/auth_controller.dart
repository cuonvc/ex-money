import 'dart:convert';

import 'package:repository/repository.dart';
import 'package:http/http.dart' as http;
import 'package:repository/src/utils/utils.dart';

import '../utils/constant.dart';

class AuthController {
  Future<dynamic> handleSignIn(SignInModel signInModel) async {

    Map<String, dynamic> deviceInfo = await getDeviceInfo();
    signInModel.deviceInfo = deviceInfo;

    return http.post(
        Uri.parse('$domain/api/auth/sign-in'),
        headers: {
          'Accept-Language': 'vi', //required
          'Content-Type': 'application/json'
        },
        body: jsonEncode(signInModel.toMap())
    );
  }

  Future<dynamic> renewAccessToken(String refreshToken) async {
    return http.get(
        Uri.parse('$domain/api/auth/token/renew?refresh_token=$refreshToken'),
    );
  }
}