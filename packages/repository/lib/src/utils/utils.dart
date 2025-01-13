import 'dart:convert';

import 'package:repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getAccessTokenDataFromDisk() async {
  final prefs= await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
  );
  final partOfPrefKey = CachedPrefKey.signInRespPref;
  final Object? authCached = prefs.get(partOfPrefKey);
  if (authCached != null) {
    List fromDisk = jsonDecode(authCached.toString());
    return fromDisk[0];
  }
  return {};
}

Future<Map<String, dynamic>> getRefreshTokenDataFromDisk() async {
  final prefs= await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(allowList: null),
  );
  final partOfPrefKey = CachedPrefKey.signInRespPref;
  final Object? authCached = prefs.get(partOfPrefKey);
  if (authCached != null) {
    List fromDisk = jsonDecode(authCached.toString());
    return fromDisk[1];
  }
  return {};
}