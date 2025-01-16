import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

Future<Map<String, dynamic>> getDeviceInfo() async {
  final deviceInfo = DeviceInfoPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? deviceToken = await messaging.getToken();
  String deviceName = '';
  String os = '';
  var version = '';
  String? deviceId;

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    deviceName = androidInfo.model;
    os = 'Android';
    version = androidInfo.version.release;
    deviceId = androidInfo.id;
  } else {
    final iosInfo = await deviceInfo.iosInfo;
    deviceName = iosInfo.utsname.machine;
    os = 'IOS';
    version = iosInfo.systemVersion;
    deviceId = iosInfo.identifierForVendor;
  }

  return {
    'deviceName': deviceName,
    'os': os,
    'version': version,
    'deviceId': deviceId,
    'deviceToken': deviceToken
  };
}