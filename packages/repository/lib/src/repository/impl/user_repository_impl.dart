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
      log('Error cached - ${e.toString()}');
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
}