import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:trekka/features/logistics/data/models/place_details.dart';

class PlaceDetailsException implements Exception {
  PlaceDetailsException(this.message);
  final String message;
}

/// Remote datasource for Google Places Details API.
class PlaceDetailsDatasource {
  PlaceDetailsDatasource({Dio? dio})
    : _dio = dio ?? Dio(),
      _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  final Dio _dio;
  final String _apiKey;
  static const String _baseUrl = 'https://places.googleapis.com/v1/places';
  static const String _fieldMask = 'id,displayName,formattedAddress,location';

  Future<PlaceDetails?> fetchPlaceDetails(String placeId) async {
    if (_apiKey.isEmpty) {
      throw PlaceDetailsException('Google Maps API Key not found in .env');
    }

    final encodedId = Uri.encodeComponent(placeId);
    final url = '$_baseUrl/$encodedId';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: <String, String>{
            'X-Goog-Api-Key': _apiKey,
            'X-Goog-FieldMask': _fieldMask,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return PlaceDetails.fromJson(data);
        }
        return null;
      }

      throw PlaceDetailsException(
        'Failed to fetch place details: ${response.statusMessage}',
      );
    } on DioException catch (error) {
      throw PlaceDetailsException(
        'Failed to fetch place details: ${error.message}',
      );
    } catch (error) {
      throw PlaceDetailsException('An unexpected error occurred: $error');
    }
  }
}
