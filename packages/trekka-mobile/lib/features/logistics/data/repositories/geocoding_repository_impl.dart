import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/datasources/geocoding_datasource.dart';
import 'package:trekka/features/logistics/data/models/geocoding_result.dart';
import 'package:trekka/features/logistics/domain/repositories/geocoding_repository.dart';

/// Implementation of GeocodingRepository
class GeocodingRepositoryImpl implements GeocodingRepository {
  GeocodingRepositoryImpl(this._datasource);

  final GeocodingDatasource _datasource;

  @override
  Future<GeocodingResult?> geocodeAddress(String address) async {
    try {
      final data = await _datasource.geocodeAddress(address);
      final results = data['results'] as List;

      if (results.isEmpty) return null;

      return GeocodingResult.fromJson(results[0] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GeocodingResult?> reverseGeocode(LatLng location) async {
    try {
      final data = await _datasource.reverseGeocode(
        location.latitude,
        location.longitude,
      );
      final results = data['results'] as List;

      if (results.isEmpty) return null;

      return GeocodingResult.fromJson(results[0] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
