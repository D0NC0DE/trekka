import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trekka/core/storage/auth_storage_service.dart';
import 'package:trekka/core/storage/secure_storage_service.dart';

/// Provider for SecureStorageService singleton
final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

/// Provider for AuthStorageService singleton
final authStorageServiceProvider = Provider<AuthStorageService>(
  (ref) => AuthStorageService(
    secureStorage: ref.watch(secureStorageServiceProvider),
  ),
);
