import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/domain/repositories/geocoding_repository.dart';
import 'package:trekka/features/logistics/presentation/providers/geocoding_provider.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';

/// ViewModel for logistics journey state
class LogisticsViewModel extends Notifier<LogisticsState> {
  late final GeocodingRepository _geocodingRepository;

  @override
  LogisticsState build() {
    _geocodingRepository = ref.read(geocodingRepositoryProvider);
    return const LogisticsState();
  }

  void setUserLocation(LatLng location) {
    state = state.copyWith(userLocation: location);
    
    // Silently fetch address in background 
    fetchUserAddress();
  }

  Future<void> fetchUserAddress() async {
    if (state.userLocation == null) return;
    
    if (state.userAddress != null && 
        state.cachedAddressLocation != null &&
        state.cachedAddressLocation == state.userLocation) {
      // Cache is valid, skip fetch
      return;
    }

    // Don't fetch if already fetching for this location
    if (state.isFetchingUserAddress && 
        state.cachedAddressLocation == state.userLocation) {
      return;
    }

    state = state.copyWith(isFetchingUserAddress: true);

    try {
      final currentLocation = state.userLocation!;
      final result = await _geocodingRepository.reverseGeocode(currentLocation);
    
      if (state.userLocation == currentLocation) {
        if (result != null) {
          state = state.copyWith(
            userAddress: result.formattedAddress,
            cachedAddressLocation: currentLocation,
            isFetchingUserAddress: false,
          );
        } else {
          state = state.copyWith(isFetchingUserAddress: false);
        }
      }
    } catch (e) {
      state = state.copyWith(isFetchingUserAddress: false);
    }
  }

  /// Set destination location and address
  void setDestination(LatLng location, String address) {
    state = state.copyWith(
      destinationLocation: location,
      destinationAddress: address,
    );
  }

  /// Clear destination
  void clearDestination() {
    state = state.copyWith(destinationLocation: null, destinationAddress: null);
  }
}
