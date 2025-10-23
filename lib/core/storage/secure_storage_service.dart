import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for secure storage operations using flutter_secure_storage
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? secureStorage})
    : _secureStorage =
          secureStorage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  final FlutterSecureStorage _secureStorage;

  Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  Future<bool> containsKey({required String key}) async {
    return await _secureStorage.containsKey(key: key);
  }
}
