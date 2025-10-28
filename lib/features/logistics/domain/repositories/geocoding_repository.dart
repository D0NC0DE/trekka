import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/models/geocoding_result.dart';

/// Abstract repository for geocoding operations
abstract class GeocodingRepository {
  /// Convert address to coordinates
  Future<GeocodingResult?> geocodeAddress(String address);

  /// Convert coordinates to address
  Future<GeocodingResult?> reverseGeocode(LatLng location);
}

