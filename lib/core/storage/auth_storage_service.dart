import 'dart:convert';

import 'package:trekka/core/storage/secure_storage_service.dart';

/// Storage keys for authentication data
class AuthStorageKeys {
  AuthStorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userJson = 'user_json';
  static const String walletJson = 'wallet_json';
}

/// Service for storing and retrieving authentication data
class AuthStorageService {
  const AuthStorageService({required SecureStorageService secureStorage})
    : _secureStorage = secureStorage;

  final SecureStorageService _secureStorage;

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: AuthStorageKeys.accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AuthStorageKeys.accessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: AuthStorageKeys.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AuthStorageKeys.refreshToken);
  }

  Future<void> saveUserJson(Map<String, dynamic> userJson) async {
    await _secureStorage.write(
      key: AuthStorageKeys.userJson,
      value: jsonEncode(userJson),
    );
  }

  Future<Map<String, dynamic>?> getUserJson() async {
    final String? jsonString = await _secureStorage.read(
      key: AuthStorageKeys.userJson,
    );
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> saveWalletJson(Map<String, dynamic> walletJson) async {
    await _secureStorage.write(
      key: AuthStorageKeys.walletJson,
      value: jsonEncode(walletJson),
    );
  }

  Future<Map<String, dynamic>?> getWalletJson() async {
    final String? jsonString = await _secureStorage.read(
      key: AuthStorageKeys.walletJson,
    );
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> user,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
      saveUserJson(user),
    ]);
  }

  Future<void> clearAuthData() async {
    await Future.wait([
      _secureStorage.delete(key: AuthStorageKeys.accessToken),
      _secureStorage.delete(key: AuthStorageKeys.refreshToken),
      _secureStorage.delete(key: AuthStorageKeys.userJson),
      _secureStorage.delete(key: AuthStorageKeys.walletJson),
    ]);
  }

  Future<bool> hasAuthData() async {
    final String? accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}
