import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Helper class to manage map camera movements
class MapCameraController {
  MapCameraController._();

  /// Fit camera bounds to show both pickup and destination
  static void fitBoundsToRoute({
    required GoogleMapController mapController,
    required LatLng pickup,
    required LatLng destination,
    double padding = 100,
  }) {
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        pickup.latitude < destination.latitude
            ? pickup.latitude
            : destination.latitude,
        pickup.longitude < destination.longitude
            ? pickup.longitude
            : destination.longitude,
      ),
      northeast: LatLng(
        pickup.latitude > destination.latitude
            ? pickup.latitude
            : destination.latitude,
        pickup.longitude > destination.longitude
            ? pickup.longitude
            : destination.longitude,
      ),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
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
