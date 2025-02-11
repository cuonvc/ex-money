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
        Uri.parse('$domain/api/auth/sign-in?locale=vi'),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(signInModel.toMap())
    );
  }

  Future<dynamic> handleOAuthSignIn(String token, String provider) async {

    Map<String, dynamic> deviceInfo = await getDeviceInfo();

    return http.post(
        Uri.parse('$domain/api/auth/oauth2/validate?locale=vi'),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'provider': provider, 'token': token, 'deviceInfo': deviceInfo})
    );
  }

  Future<dynamic> renewAccessToken(String refreshToken) async {
    return http.get(
        Uri.parse('$domain/api/auth/token/renew?refresh_token=$refreshToken'),
    );
  }

  Future<dynamic> updateProfile(String name) async {

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    return http.put(
        Uri.parse('$domain/api/user/account/edit?locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'name': name})
    );
  }

  Future<dynamic> turnNotification(bool on) async {

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    return http.put(
        Uri.parse('$domain/api/notification/turn?on=$on&locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}'
        }
    );
  }

  Future<dynamic> changePassword(String oldPassword, String newPassword, String passwordConfirm) async {

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    return http.put(
        Uri.parse('$domain/api/user/password-change?locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'oldPassword': oldPassword, 'newPassword': newPassword, 'retypePassword': passwordConfirm})
    );
  }

  Future<dynamic> handleSignOut() async {

    Map<String, dynamic> accessTokenData = await getAccessTokenDataFromDisk();

    return http.post(
        Uri.parse('$domain/api/auth/sign-out?locale=vi'),
        headers: {
          'Authorization': '${accessTokenData['tokenType']} ${accessTokenData['token']}'
        }
    );
  }
}