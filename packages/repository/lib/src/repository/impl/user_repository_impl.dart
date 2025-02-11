import 'dart:convert';
import 'dart:developer';

import 'package:repository/repository.dart';
import 'package:repository/src/controllers/auth_controller.dart';
import 'package:repository/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {

  final authController = AuthController();

  @override
  Future<dynamic> signIn(SignInModel signModel) async {
    try {
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await authController.handleSignIn(signModel)).bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log('Error login - ${e.toString()}');
      return HttpResponse.toError(e.toString(), null);
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
      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode((await authController.handleSignOut()).bodyBytes));
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
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Update profile error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future turnNotification(bool on) async {
    try {
      var resp = await authController.turnNotification(on);
      if (resp.statusCode == 401) {
        await this.renewAccessToken();
        resp = await authController.turnNotification(on);
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Turn notification error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }

  @override
  Future changePassword(String oldPassword, String newPassword, String passwordConfirm) async {
    try {
      var resp = await authController.changePassword(oldPassword, newPassword, passwordConfirm);
      if (resp.statusCode == 401) {
        await this.renewAccessToken();
        resp = await authController.changePassword(oldPassword, newPassword, passwordConfirm);
      }

      final Map<String, dynamic> mapResponse = jsonDecode(
          utf8.decode(resp.bodyBytes));
      return HttpResponse.toObject(mapResponse);
    } catch (e) {
      log("Change password error - $e");
      return HttpResponse.toError(e.toString(), null);
    }
  }
}