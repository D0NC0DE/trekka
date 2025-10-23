/// Environment configuration for the app
class EnvConfig {
  const EnvConfig._();

  /// API base URL from dart-define or fallback to localhost
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3001',
  );

  /// Whether to use mock data sources instead of real API
  static const bool useMocks = bool.fromEnvironment(
    'USE_MOCKS',
    defaultValue: false,
  );

  /// Whether the app is in production mode
  static const bool isProduction = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: false,
  );

  /// Whether to enable network logging
  static bool get enableNetworkLogging => !isProduction;
}

