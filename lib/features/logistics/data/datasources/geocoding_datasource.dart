import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Remote datasource for Google Geocoding API
class GeocodingDatasource {
  GeocodingDatasource({Dio? dio})
    : _dio = dio ?? Dio(),
      _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  final Dio _dio;
  final String _apiKey;
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';

  /// Forward geocoding: address to coordinates
  Future<Map<String, dynamic>> geocodeAddress(String address) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {'address': address, 'key': _apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to geocode address');
    }

    return response.data as Map<String, dynamic>;
  }

  /// Reverse geocoding: coordinates to address
  Future<Map<String, dynamic>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {'latlng': '$latitude,$longitude', 'key': _apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reverse geocode');
    }

    return response.data as Map<String, dynamic>;
  }
}
