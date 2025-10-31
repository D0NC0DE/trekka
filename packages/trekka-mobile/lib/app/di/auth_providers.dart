import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trekka/app/config/env_config.dart';
import 'package:trekka/app/di/network_providers.dart';
import 'package:trekka/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:trekka/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:trekka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:trekka/features/auth/domain/repositories/auth_repository.dart';

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  if (EnvConfig.useMocks) {
    return const AuthMockDataSource();
  }
  return AuthRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  ),
);
