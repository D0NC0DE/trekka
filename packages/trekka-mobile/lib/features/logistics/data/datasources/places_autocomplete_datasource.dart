import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/models/place_autocomplete_prediction.dart';

class PlacesAutocompleteException implements Exception {
  PlacesAutocompleteException(this.message);
  final String message;
}

/// Datasource for Google Places Autocomplete API
class PlacesAutocompleteDatasource {
  final Dio _dio = Dio();
  final String _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://places.googleapis.com/v1/places:autocomplete';

  /// Get place predictions based on input text
  Future<List<PlaceAutocompletePrediction>> getPlacePredictions({
    required String input,
    LatLng? origin,
    String? regionCode,
  }) async {
    if (_apiKey.isEmpty) {
      throw PlacesAutocompleteException(
        'Google Maps API Key not found in .env',
      );
    }

    if (input.trim().isEmpty) {
      return [];
    }

    try {
      final Map<String, dynamic> requestBody = {'input': input};

      // Add origin if provided
      if (origin != null) {
        requestBody['origin'] = {
          'latitude': origin.latitude,
          'longitude': origin.longitude,
        };
      }

      // Add region code if provided
      if (regionCode != null && regionCode.isNotEmpty) {
        requestBody['includedRegionCodes'] = [regionCode];
      }

      final Response<dynamic> response = await _dio.post(
        _baseUrl,
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': _apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final suggestions = response.data['suggestions'] as List<dynamic>?;

        if (suggestions == null || suggestions.isEmpty) {
          return [];
        }

        final predictions = suggestions
            .where((s) => s['placePrediction'] != null)
            .map(
              (s) => PlaceAutocompletePrediction.fromJson(
                s as Map<String, dynamic>,
              ),
            )
            .toList();

        return predictions;
      }

      return [];
    } on DioException catch (e) {
      throw PlacesAutocompleteException(
        'Failed to get predictions: ${e.message}',
      );
    } catch (e) {
      throw PlacesAutocompleteException('An unexpected error occurred: $e');
    }
  }
}
