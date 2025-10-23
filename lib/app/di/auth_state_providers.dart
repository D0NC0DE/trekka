import 'package:flutter_riverpod/legacy.dart';
import 'package:trekka/app/di/network_providers.dart';
import 'package:trekka/app/di/storage_providers.dart';
import 'package:trekka/app/di/users_providers.dart';
import 'package:trekka/app/di/wallets_providers.dart';
import 'package:trekka/app/state/auth_notifier.dart';
import 'package:trekka/app/state/auth_state.dart';

/// Provider for global authentication state
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    authStorage: ref.read(authStorageServiceProvider),
    usersRepository: ref.read(usersRepositoryProvider),
    walletsRepository: ref.read(walletsRepositoryProvider),
    apiClient: ref.read(apiClientProvider),
  ),
);
