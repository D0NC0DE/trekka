import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Helper class to manage map camera movements
class MapCameraController {
  MapCameraController._();

  /// Fit camera bounds to show both pickup and destination
  static Future<void> fitBoundsToRoute({
    required GoogleMapController mapController,
    required LatLng pickup,
    required LatLng destination,
    double horizontalPadding = 0,
    double topPadding = 10,
    double bottomPadding = 400,
  }) async {
    // Calculate bounds
    final double minLat = math.min(pickup.latitude, destination.latitude);
    final double maxLat = math.max(pickup.latitude, destination.latitude);
    final double minLng = math.min(pickup.longitude, destination.longitude);
    final double maxLng = math.max(pickup.longitude, destination.longitude);

    // Calculate center with offset towards top (to avoid bottom sheet)
    final double latDiff = maxLat - minLat;
    final double lngDiff = maxLng - minLng;
    
    final double centerLat = minLat + (latDiff * 0.6);
    final double centerLng = minLng + (lngDiff / 2);

    final double distance = _calculateDistance(pickup, destination);
    final double zoom = _calculateZoomLevel(distance);

    // Animate to the adjusted center with calculated zoom
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(centerLat, centerLng),
          zoom: zoom,
          tilt: 20,
        ),
      ),
    );
  }

  /// Calculate distance between two points in kilometers
  static double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // km

    final double lat1Rad = point1.latitude * math.pi / 180;
    final double lat2Rad = point2.latitude * math.pi / 180;
    final double latDiff = (point2.latitude - point1.latitude) * math.pi / 180;
    final double lngDiff = (point2.longitude - point1.longitude) * math.pi / 180;

    final double a = math.sin(latDiff / 2) * math.sin(latDiff / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(lngDiff / 2) *
            math.sin(lngDiff / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Calculate appropriate zoom level based on distance
  static double _calculateZoomLevel(double distanceKm) {
    if (distanceKm < 0.5) return 16.0;
    if (distanceKm < 1) return 15.0;
    if (distanceKm < 2) return 14.5;
    if (distanceKm < 5) return 13.5;
    if (distanceKm < 10) return 12.5;
    if (distanceKm < 20) return 11.5;
    if (distanceKm < 50) return 10.0;
    return 9.0;
  }

  /// Animate camera to a specific location
  static void animateToLocation({
    required GoogleMapController mapController,
    required LatLng target,
    double zoom = 17.0,
    double tilt = 20.0,
  }) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom, tilt: tilt),
      ),
    );
  }

  /// Move camera to a specific location (no animation)
  static void moveToLocation({
    required GoogleMapController mapController,
    required LatLng target,
    double zoom = 17.0,
    double tilt = 20.0,
  }) {
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom, tilt: tilt),
      ),
    );
  }
}
