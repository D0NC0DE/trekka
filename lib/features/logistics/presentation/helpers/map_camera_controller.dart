import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Helper class to manage map camera movements
class MapCameraController {
  MapCameraController._();

  /// Fit camera bounds to show both pickup and destination ABOVE the bottom modal
  static Future<void> fitBoundsToRoute({
    required GoogleMapController mapController,
    required LatLng pickup,
    required LatLng destination,
  }) async {
    final double minLat = math.min(pickup.latitude, destination.latitude);
    final double maxLat = math.max(pickup.latitude, destination.latitude);
    final double minLng = math.min(pickup.longitude, destination.longitude);
    final double maxLng = math.max(pickup.longitude, destination.longitude);

    final double latSpan = (maxLat - minLat).abs();
    final double lngSpan = (maxLng - minLng).abs();

    final double baseLatPadding = latSpan == 0 ? 0.01 : latSpan * 0.35;
    final double baseLngPadding = lngSpan == 0 ? 0.01 : lngSpan * 0.4;

    final double southPadding = baseLatPadding * 2.4;
    final double northPadding = baseLatPadding * 0.8;

    final double centerLng = (minLng + maxLng) / 2;

    final LatLngBounds expandedBounds = LatLngBounds(
      southwest: LatLng(
        (minLat - southPadding).clamp(-90.0, 90.0),
        (centerLng - baseLngPadding * 1.2).clamp(-180.0, 180.0),
      ),
      northeast: LatLng(
        (maxLat + northPadding).clamp(-90.0, 90.0),
        (centerLng + baseLngPadding * 1.2).clamp(-180.0, 180.0),
      ),
    );

    await mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        expandedBounds,
        40, // Small padding at edges
      ),
    );
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
