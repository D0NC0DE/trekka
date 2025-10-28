import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/features/logistics/domain/entities/logistics_stage.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';

class MapMarkerBuilder {
  MapMarkerBuilder._();

  static Set<Marker> buildMarkers({
    required LogisticsState logisticsState,
    required LogisticsStage currentStage,
    required BitmapDescriptor? riderIcon,
    BitmapDescriptor? destinationIcon,
    LatLng? fallbackUserLocation,
    Set<Marker>? nearbyDriverMarkers,
    BitmapDescriptor? animatedPickupIcon,
  }) {
    final LatLng? pickupLocation =
        logisticsState.userLocation ?? fallbackUserLocation;

    if (pickupLocation == null) {
      return <Marker>{};
    }

    // Use animated pickup marker during "looking for driver" stage
    final bool shouldAnimatePickup = currentStage == LogisticsStage.lookingForDriver;
    final pickupMarkerIcon = shouldAnimatePickup && animatedPickupIcon != null
        ? animatedPickupIcon
        : (riderIcon ?? BitmapDescriptor.defaultMarker);

    final Set<Marker> markers = <Marker>{
      Marker(
        markerId: const MarkerId('user-location'),
        position: pickupLocation,
        icon: pickupMarkerIcon,
        infoWindow: const InfoWindow(title: 'Pickup location'),
      ),
    };

    if (_shouldShowDestinationMarker(currentStage) &&
        logisticsState.destinationLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: logisticsState.destinationLocation!,
          icon:
              destinationIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );
    }

    // Add nearby driver markers if provided (for lookingForDriver stage)
    if (nearbyDriverMarkers != null && currentStage == LogisticsStage.lookingForDriver) {
      markers.addAll(nearbyDriverMarkers);
    }

    return markers;
  }

  static bool _shouldShowDestinationMarker(LogisticsStage stage) {
    return stage == LogisticsStage.confirmRequest ||
        stage == LogisticsStage.lookingForDriver ||
        stage == LogisticsStage.waitingForDriver ||
        stage == LogisticsStage.driverArrived ||
        stage == LogisticsStage.inProgress;
  }

  static Future<BitmapDescriptor?> loadRiderIcon() async {
    try {
      return await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(24, 24)),
        AppAssetIcons.riderMarker,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<BitmapDescriptor?> loadDestinationIcon() async {
    try {
      return await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(24, 24)),
        AppAssetIcons.destinationMarker,
      );
    } catch (e) {
      return null;
    }
  }
}
