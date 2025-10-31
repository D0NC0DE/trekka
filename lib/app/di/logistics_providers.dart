import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trekka/app/config/env_config.dart';
import 'package:trekka/app/di/network_providers.dart';
import 'package:trekka/features/logistics/data/datasources/logistics_remote_datasource.dart';
import 'package:trekka/features/logistics/data/repositories/logistics_repository_impl.dart';
import 'package:trekka/features/logistics/data/services/logistics_socket_service.dart';
import 'package:trekka/features/logistics/domain/repositories/logistics_repository.dart';

/// Provider for logistics remote datasource.
final logisticsRemoteDataSourceProvider = Provider<LogisticsRemoteDataSource>(
  (ref) => LogisticsRemoteDataSource(apiClient: ref.watch(apiClientProvider)),
);

/// Provider for logistics repository.
final logisticsRepositoryProvider = Provider<LogisticsRepository>(
  (ref) =>
      LogisticsRepositoryImpl(ref.watch(logisticsRemoteDataSourceProvider)),
);

/// Provider for logistics websocket service.
final logisticsSocketServiceProvider = Provider<LogisticsSocketService>(
  (ref) => LogisticsSocketService(baseUrl: EnvConfig.apiBaseUrl),
);
