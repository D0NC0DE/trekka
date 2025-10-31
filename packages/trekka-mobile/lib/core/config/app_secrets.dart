import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides typed access to sensitive configuration values loaded from `.env`.
class AppSecrets {
  AppSecrets._();

  /// Google Maps SDK API key.
  static String get googleMapsApiKey => _read('GOOGLE_MAPS_API_KEY');

  /// Read an environment value or return the provided fallback.
  static String _read(String key, {String fallback = ''}) {
    final String? value = dotenv.env[key];
    if (value == null || value.isEmpty) return fallback;
    return value;
  }
}
