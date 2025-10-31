import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration for the app.
class EnvConfig {
  EnvConfig._();

  static const String _defaultApiBaseUrl = 'http://localhost:3000';
  static const String _dartDefineApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultApiBaseUrl,
  );
  static const bool _dartDefineUseMocks = bool.fromEnvironment(
    'USE_MOCKS',
    defaultValue: false,
  );
  static const bool _dartDefineIsProduction = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: false,
  );

  /// API base URL from `.env` or dart-define with a sensible default.
  static String get apiBaseUrl {
    final String? envValue = dotenv.env['API_BASE_URL'];
    if (envValue != null && envValue.isNotEmpty) {
      return envValue;
    }
    return _dartDefineApiBaseUrl;
  }

  /// Whether to use mock data sources instead of real API.
  static bool get useMocks {
    final String? envValue = dotenv.env['USE_MOCKS'];
    if (envValue != null && envValue.isNotEmpty) {
      return _parseBool(envValue, fallback: _dartDefineUseMocks);
    }
    return _dartDefineUseMocks;
  }

  /// Whether the app is in production mode.
  static bool get isProduction {
    final String? envValue = dotenv.env['IS_PRODUCTION'];
    if (envValue != null && envValue.isNotEmpty) {
      return _parseBool(envValue, fallback: _dartDefineIsProduction);
    }
    return _dartDefineIsProduction;
  }

  /// Whether to enable network logging.
  static bool get enableNetworkLogging => !isProduction;

  static bool _parseBool(String value, {required bool fallback}) {
    final String normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
    return fallback;
  }
}
