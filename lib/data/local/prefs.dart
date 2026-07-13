import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  late SharedPreferences _prefs;

  static const _keyAuthToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyFlavor = 'flavor';
  static const _keyGuestUser = 'guest_user';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth
  String? getAuthToken() => _prefs.getString(_keyAuthToken);
  Future<void> setAuthToken(String token) => _prefs.setString(_keyAuthToken, token);

  String? getRefreshToken() => _prefs.getString(_keyRefreshToken);
  Future<void> setRefreshToken(String token) => _prefs.setString(_keyRefreshToken, token);

  Future<void> clearAuth() async {
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_keyRefreshToken);
  }

  // App
  String? getFlavor() => _prefs.getString(_keyFlavor);
  Future<void> setFlavor(String flavor) => _prefs.setString(_keyFlavor, flavor);

  bool isGuestUser() => _prefs.getBool(_keyGuestUser) ?? false;
  Future<void> setGuestUser(bool value) => _prefs.setBool(_keyGuestUser, value);
}
