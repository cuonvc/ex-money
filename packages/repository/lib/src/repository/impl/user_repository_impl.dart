import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/auth_controller.dart';
import 'package:repository/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {

  final authController = AuthController();

  @override
  Future signUp(SignUpModel model) async {
    try {
      dynamic resp = await authController.handleSignUp(model);
      if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error to signup - ${e.toString()}');
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future activeAccount(SignUpModel model, String activeCode) async {
    try {
      dynamic resp = await authController.handleActiveAccount(model, activeCode);
      if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error to Active account - ${e.toString()}');
      return HttpResponse.toError(e.toString(), 403);
    }
  }

  @override
  Future<dynamic> signIn(SignInModel signModel) async {
    try {
      dynamic resp = await authController.handleSignIn(signModel);
      if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error login - ${e.toString()}');
      return HttpResponse.toError(e.toString(), 403);
    }
  }

  @override
  Future oAuthSignIn(String token, String provider) async {
    try {
      dynamic resp = await authController.handleOAuthSignIn(token, provider);
      if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error login via OAuth $provider - ${e.toString()}');
      return HttpResponse.toError(e.toString(), 403);
    }
  }

  @override
  Future<void> renewAccessToken() async {
    try {
      Map<String, dynamic> refreshTokenData = await getRefreshTokenDataFromDisk();

      final prefs= await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
      );
      final partOfPrefKey = CachedPrefKey.signInRespPref;

      var rp = await authController.renewAccessToken(refreshTokenData['token']);
      if (rp.statusCode == 401 || rp.statusCode == 403) {
        log('---------> Refresh token expired');
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(await rp.bodyBytes));
      HttpResponse response = HttpResponse.toObject(mapResponse);

      await prefs.setString(partOfPrefKey, jsonEncode(response.data));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future signOut() async {
    try {
      dynamic resp = await authController.handleSignOut();
      if (resp.statusCode == 401) {
        await this.renewAccessToken();
        resp = await authController.handleSignOut();
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((resp).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error sign out - ${e.toString()}');
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future updateProfile(String name) async {
    try {
      var resp = await authController.updateProfile(name);
      if (resp.statusCode == 401) {
        await this.renewAccessToken();
        resp = await authController.updateProfile(name);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Update profile error - $e");
      return HttpResponse.toError(sessionExpired, 403);
    }
  }

  @override
  Future turnNotification(bool on) async {
    try {
      var resp = await authController.turnNotification(on);
      if (resp.statusCode == 401) {
        await this.renewAccessToken();
        resp = await authController.turnNotification(on);
      } else if (resp.statusCode == 404) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Turn notification error - $e");
      return HttpResponse.toError(sessionExpired, 403);
    }
  }

  @override
  Future changePassword(String oldPassword, String newPassword, String passwordConfirm) async {
    try {
      var resp = await authController.changePassword(oldPassword, newPassword, passwordConfirm);
      if (resp.statusCode == 401) {
        await this.renewAccessToken();
        resp = await authController.changePassword(oldPassword, newPassword, passwordConfirm);
      } else if (resp.statusCode == 401) {
        return HttpResponse.notFound();
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Change password error - $e");
      return HttpResponse.toError(sessionExpired, 403);
    }
  }
}