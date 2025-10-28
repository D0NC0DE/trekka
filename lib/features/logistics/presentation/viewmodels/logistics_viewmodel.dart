import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/models/place_autocomplete_prediction.dart';
import 'package:trekka/features/logistics/domain/repositories/geocoding_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/place_details_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/places_autocomplete_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/routes_repository.dart';
import 'package:trekka/features/logistics/presentation/providers/geocoding_provider.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';

/// ViewModel for logistics journey state
class LogisticsViewModel extends Notifier<LogisticsState> {
  late final GeocodingRepository _geocodingRepository;
  late final PlacesAutocompleteRepository _placesRepository;
  late final PlaceDetailsRepository _placeDetailsRepository;
  late final RoutesRepository _routesRepository;

  @override
  LogisticsState build() {
    _geocodingRepository = ref.read(geocodingRepositoryProvider);
    _placesRepository = ref.read(placesAutocompleteRepositoryProvider);
    _placeDetailsRepository = ref.read(placeDetailsRepositoryProvider);
    _routesRepository = ref.read(routesRepositoryProvider);
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
    fetchRouteInfo();
  }

  /// Fetch route info (distance and duration) between origin and destination
  Future<void> fetchRouteInfo() async {
    if (state.userLocation == null || state.destinationLocation == null) {
      return;
    }

    state = state.copyWith(isFetchingRoute: true);

    try {
      final routeInfo = await _routesRepository.getRouteInfo(
        origin: state.userLocation!,
        destination: state.destinationLocation!,
        travelMode: 'DRIVE',
      );

      state = state.copyWith(routeInfo: routeInfo, isFetchingRoute: false);
    } catch (e) {
      debugPrint('Failed to fetch route info: $e');
      state = state.copyWith(isFetchingRoute: false);
    }
  }

  void _setPickupDetails({LatLng? location, required String address}) {
    state = state.copyWith(
      userAddress: address,
      userLocation: location ?? state.userLocation,
      cachedAddressLocation: location ?? state.cachedAddressLocation,
      isFetchingUserAddress: false,
    );
    
    fetchRouteInfo();
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

  Future<void> selectPrediction(PlaceAutocompletePrediction prediction) async {
    LatLng? resolvedLocation;
    String resolvedAddress = prediction.fullText;

    try {
      final details = await _placeDetailsRepository.getPlaceDetails(
        prediction.placeId,
      );

      if (details != null) {
        resolvedLocation = details.location ?? resolvedLocation;
        resolvedAddress = details.formattedAddress ?? resolvedAddress;
      }

      if (resolvedLocation == null) {
        final geocode = await _geocodingRepository.geocodeAddress(
          prediction.fullText,
        );
        if (geocode != null) {
          resolvedLocation = geocode.location;
          resolvedAddress = geocode.formattedAddress;
        }
      }

      if (resolvedLocation != null) {
        setDestination(resolvedLocation, resolvedAddress);
      } else {
        state = state.copyWith(destinationAddress: resolvedAddress);
      }
    } catch (error) {
      debugPrint('Failed to select prediction: $error');
    } finally {
      clearPredictions();
    }
  }

  Future<void> selectPickupPrediction(
    PlaceAutocompletePrediction prediction,
  ) async {
    LatLng? resolvedLocation;
    String resolvedAddress = prediction.fullText;

    try {
      final details = await _placeDetailsRepository.getPlaceDetails(
        prediction.placeId,
      );

      if (details != null) {
        resolvedLocation = details.location ?? resolvedLocation;
        resolvedAddress = details.formattedAddress ?? resolvedAddress;
      }

      if (resolvedLocation == null) {
        final geocode = await _geocodingRepository.geocodeAddress(
          prediction.fullText,
        );
        if (geocode != null) {
          resolvedLocation = geocode.location;
          resolvedAddress = geocode.formattedAddress;
        }
      }

      _setPickupDetails(location: resolvedLocation, address: resolvedAddress);
    } catch (error) {
      debugPrint('Failed to select pickup prediction: $error');
    } finally {
      clearPredictions();
    }
  }
}
