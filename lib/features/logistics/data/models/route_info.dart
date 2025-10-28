import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Result from Google Routes API containing distance, duration, and polyline
class RouteInfo {
  const RouteInfo({
    required this.distanceMeters,
    required this.durationSeconds,
    this.encodedPolyline,
  });

  final int distanceMeters;
  final int durationSeconds;
  final String? encodedPolyline;

  Duration get duration => Duration(seconds: durationSeconds);

  double get distanceKm => distanceMeters / 1000;

  /// Decode the polyline to a list of LatLng points
  List<LatLng>? decodePolyline() {
    if (encodedPolyline == null || encodedPolyline!.isEmpty) {
      return null;
    }
    return _decodePolyline(encodedPolyline!);
  }

  /// Decode an encoded polyline string into a list of LatLng points
  static List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    final routes = json['routes'] as List?;
    if (routes == null || routes.isEmpty) {
      throw Exception('No routes found in response');
    }

    final route = routes[0] as Map<String, dynamic>;

    final distanceMeters = route['distanceMeters'] as int?;

    final durationStr = route['duration'] as String?;

    if (distanceMeters == null || durationStr == null) {
      throw Exception('Missing distance or duration in route response');
    }

    final durationSeconds = int.parse(durationStr.replaceAll('s', ''));

    // Extract encoded polyline if available
    String? encodedPolyline;
    if (route.containsKey('polyline')) {
      final polylineData = route['polyline'] as Map<String, dynamic>?;
      encodedPolyline = polylineData?['encodedPolyline'] as String?;
    }

    return RouteInfo(
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
      encodedPolyline: encodedPolyline,
    );
  }
}
