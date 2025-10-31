import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trekka/app/config/env_config.dart';
import 'package:trekka/app/di/network_providers.dart';
import 'package:trekka/features/wallets/data/datasources/wallets_mock_datasource.dart';
import 'package:trekka/features/wallets/data/datasources/wallets_remote_datasource.dart';
import 'package:trekka/features/wallets/data/repositories/wallets_repository_impl.dart';
import 'package:trekka/features/wallets/domain/repositories/wallets_repository.dart';

/// Provider for WalletsRemoteDataSource
final walletsRemoteDataSourceProvider = Provider<WalletsRemoteDataSource>((
  ref,
) {
  if (EnvConfig.useMocks) {
    return const WalletsMockDataSource();
  }
  return WalletsRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

/// Provider for WalletsRepository
final walletsRepositoryProvider = Provider<WalletsRepository>(
  (ref) => WalletsRepositoryImpl(
    remoteDataSource: ref.watch(walletsRemoteDataSourceProvider),
  ),
);
