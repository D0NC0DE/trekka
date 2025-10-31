import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trekka/app/config/env_config.dart';
import 'package:trekka/core/network/api_client.dart';

/// Provider for ApiClient singleton
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    baseUrl: EnvConfig.apiBaseUrl,
    enableLogging: EnvConfig.enableNetworkLogging,
  ),
);
