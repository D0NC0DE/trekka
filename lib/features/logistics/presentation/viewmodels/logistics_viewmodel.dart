import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/models/place_autocomplete_prediction.dart';
import 'package:trekka/features/logistics/domain/repositories/geocoding_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/places_autocomplete_repository.dart';
import 'package:trekka/features/logistics/presentation/providers/geocoding_provider.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';

/// ViewModel for logistics journey state
class LogisticsViewModel extends Notifier<LogisticsState> {
  late final GeocodingRepository _geocodingRepository;
  late final PlacesAutocompleteRepository _placesRepository;

  @override
  LogisticsState build() {
    _geocodingRepository = ref.read(geocodingRepositoryProvider);
    _placesRepository = ref.read(placesAutocompleteRepositoryProvider);
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
      return;
    }

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

  void clearDestination() {
    state = state.copyWith(destinationLocation: null, destinationAddress: null);
  }

  String? _extractRegionCode(String? address) {
    if (address == null) return null;

    final parts = address.split(',');
    if (parts.length >= 2) {
      final lastPart = parts.last.trim();
      const countryMap = {
        'Nigeria': 'NG',
        'USA': 'US',
        'United States': 'US',
        'UK': 'GB',
        'United Kingdom': 'GB',
        'Canada': 'CA',
        // TODO: Add more countries as needed
      };
      return countryMap[lastPart];
    }
    return null;
  }

  Future<void> searchPlaces(String input) async {
    if (input.trim().isEmpty) {
      state = state.copyWith(predictions: [], isFetchingPredictions: false);
      return;
    }

    state = state.copyWith(isFetchingPredictions: true);

    try {
      final regionCode = _extractRegionCode(state.userAddress);

      final predictions = await _placesRepository.getPlacePredictions(
        input: input,
        origin: state.userLocation,
        regionCode: regionCode,
      );

      state = state.copyWith(
        predictions: predictions,
        isFetchingPredictions: false,
      );
    } catch (e) {
      debugPrint('Failed to fetch predictions: $e');
      state = state.copyWith(predictions: [], isFetchingPredictions: false);
    }
  }

  void clearPredictions() {
    state = state.copyWith(predictions: [], isFetchingPredictions: false);
  }

  void selectPrediction(PlaceAutocompletePrediction prediction) {
    // TODO: Fetch place details to get LatLng
    debugPrint('Selected prediction: ${prediction.placeId}');
    clearPredictions();
  }
}
