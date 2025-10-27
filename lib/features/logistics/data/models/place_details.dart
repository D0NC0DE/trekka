import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Represents detailed information about a place from Google Places API.
class PlaceDetails {
  const PlaceDetails({
    required this.placeId,
    this.displayName,
    this.formattedAddress,
    this.location,
  });

  final String placeId;
  final String? displayName;
  final String? formattedAddress;
  final LatLng? location;

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    LatLng? location;
    final locationJson = json['location'] as Map<String, dynamic>?;
    if (locationJson != null) {
      final latitude = locationJson['latitude'];
      final longitude = locationJson['longitude'];
      if (latitude is num && longitude is num) {
        location = LatLng(latitude.toDouble(), longitude.toDouble());
      }
    }

    final displayNameJson = json['displayName'] as Map<String, dynamic>?;

    return PlaceDetails(
      placeId: json['id'] as String? ?? '',
      displayName: displayNameJson != null
          ? displayNameJson['text'] as String?
          : null,
      formattedAddress: json['formattedAddress'] as String?,
      location: location,
    );
  }
}
