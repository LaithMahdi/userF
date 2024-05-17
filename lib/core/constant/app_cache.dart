import 'package:user/main.dart';

class AppCache {
  AppCache();
  final String _tokenKey = "TOKEN_KEY";
  final String _userIdKey = "USER_ID_KEY";

  Future<void> setToken(String value) async =>
      await sharedPref!.setString(_tokenKey, value);

  String getToken() => sharedPref!.getString(_tokenKey) ?? "";

  Future<void> setUserId(String value) async =>
      await sharedPref!.setString(_userIdKey, value);

  String getUserId() => sharedPref!.getString(_userIdKey) ?? "";

  Future<void> clearCache() async {
    await sharedPref!.remove(_tokenKey);
    await sharedPref!.remove(_userIdKey);
  }
}
