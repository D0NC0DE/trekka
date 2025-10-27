import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RoutesDatasource {
  RoutesDatasource({Dio? dio})
    : _dio = dio ?? Dio(),
      _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  final Dio _dio;
  final String _apiKey;
  static const String _baseUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';

  /// Compute route between origin and destination
  ///
  /// Returns distance and duration using the Routes API.
  Future<Map<String, dynamic>> computeRoute({
    required String originLat,
    required String originLng,
    required String destinationLat,
    required String destinationLng,
    String travelMode = 'DRIVE', // DRIVE, BICYCLE, WALK, TWO_WHEELER, TRANSIT
  }) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': _apiKey,
            'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters',
          },
        ),
        data: {
          'origin': {
            'location': {
              'latLng': {'latitude': originLat, 'longitude': originLng},
            },
          },
          'destination': {
            'location': {
              'latLng': {
                'latitude': destinationLat,
                'longitude': destinationLng,
              },
            },
          },
          'travelMode': travelMode,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to compute route: ${response.statusCode}');
      }

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch route: $e');
    }
  }
}
