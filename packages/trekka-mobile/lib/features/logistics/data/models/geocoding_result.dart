import 'package:google_maps_flutter/google_maps_flutter.dart';

/// DTO for geocoding result from Google Maps API
class GeocodingResult {
  const GeocodingResult({
    required this.formattedAddress,
    required this.location,
  });

  final String formattedAddress;
  final LatLng location;

  factory GeocodingResult.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>;
    final locationData = geometry['location'] as Map<String, dynamic>;

    return GeocodingResult(
      formattedAddress: json['formatted_address'] as String,
      location: LatLng(
        locationData['lat'] as double,
        locationData['lng'] as double,
      ),
    );
  }
}
