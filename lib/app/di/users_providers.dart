import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trekka/app/config/env_config.dart';
import 'package:trekka/app/di/network_providers.dart';
import 'package:trekka/features/profile/data/datasources/users_mock_datasource.dart';
import 'package:trekka/features/profile/data/datasources/users_remote_datasource.dart';
import 'package:trekka/features/profile/data/repositories/users_repository_impl.dart';
import 'package:trekka/features/profile/domain/repositories/users_repository.dart';

/// Provider for UsersRemoteDataSource
final usersRemoteDataSourceProvider = Provider<UsersRemoteDataSource>((ref) {
  if (EnvConfig.useMocks) {
    return const UsersMockDataSource();
  }
  return UsersRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

/// Provider for UsersRepository
final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) => UsersRepositoryImpl(
    remoteDataSource: ref.watch(usersRemoteDataSourceProvider),
  ),
);
