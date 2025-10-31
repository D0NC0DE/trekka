import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/app/di/logistics_providers.dart';
import 'package:trekka/app/di/storage_providers.dart';
import 'package:trekka/core/storage/auth_storage_service.dart';
import 'package:trekka/features/logistics/data/models/place_autocomplete_prediction.dart';
import 'package:trekka/features/logistics/data/models/route_info.dart';
import 'package:trekka/features/logistics/data/services/logistics_socket_service.dart';
import 'package:trekka/features/logistics/domain/repositories/geocoding_repository.dart';
import 'package:trekka/features/logistics/domain/entities/logistics_stage.dart';
import 'package:trekka/features/logistics/domain/entities/ride_request.dart';
import 'package:trekka/features/logistics/domain/repositories/place_details_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/places_autocomplete_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/logistics_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/routes_repository.dart';
import 'package:trekka/features/logistics/presentation/providers/geocoding_provider.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';

/// ViewModel for logistics journey state
class LogisticsViewModel extends Notifier<LogisticsState> {
  late final GeocodingRepository _geocodingRepository;
  late final PlacesAutocompleteRepository _placesRepository;
  late final PlaceDetailsRepository _placeDetailsRepository;
  late final RoutesRepository _routesRepository;
  late final LogisticsRepository _logisticsRepository;
  late final LogisticsSocketService _socketService;
  late final AuthStorageService _authStorageService;
  String? _trackedRideId;

  @override
  LogisticsState build() {
    _geocodingRepository = ref.read(geocodingRepositoryProvider);
    _placesRepository = ref.read(placesAutocompleteRepositoryProvider);
    _placeDetailsRepository = ref.read(placeDetailsRepositoryProvider);
    _routesRepository = ref.read(routesRepositoryProvider);
    _logisticsRepository = ref.read(logisticsRepositoryProvider);
    _socketService = ref.read(logisticsSocketServiceProvider);
    _authStorageService = ref.read(authStorageServiceProvider);
    ref.onDispose(_unsubscribeFromRideUpdates);
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
      quote: null,
      selectedPrice: null,
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

      state = state.copyWith(
        routeInfo: routeInfo,
        isFetchingRoute: false,
        quote: null,
        selectedPrice: null,
      );

      if (routeInfo != null) {
        await _loadHailingQuote(routeInfo);
      }
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
    state = state.copyWith(
      destinationLocation: null,
      destinationAddress: null,
      routeInfo: null,
      quote: null,
      selectedPrice: null,
    );
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
      state = state.copyWith(
        predictions: <PlaceAutocompletePrediction>[],
        isFetchingPredictions: false,
      );
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
      state = state.copyWith(
        predictions: <PlaceAutocompletePrediction>[],
        isFetchingPredictions: false,
      );
    }
  }

  void clearPredictions() {
    state = state.copyWith(
      predictions: <PlaceAutocompletePrediction>[],
      isFetchingPredictions: false,
    );
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

  void setStage(LogisticsStage stage) {
    if (state.stage == stage) return;
    state = state.copyWith(stage: stage);
  }

  void clearError() {
    if (state.errorMessage == null) return;
    state = state.copyWith(errorMessage: null);
  }

  void updateSelectedPrice(double value) {
    final double sanitized = value.clamp(0, double.infinity);
    state = state.copyWith(selectedPrice: sanitized);
  }

  Future<void> _loadHailingQuote(RouteInfo routeInfo) async {
    state = state.copyWith(isFetchingQuote: true, errorMessage: null);

    try {
      final double distanceKm = routeInfo.distanceKm;
      final double estimatedMinutes = routeInfo.duration.inSeconds / 60.0;

      final quote = await _logisticsRepository.fetchHailingQuote(
        distanceKm: distanceKm,
        estimatedTimeMinutes: estimatedMinutes,
      );

      state = state.copyWith(
        quote: quote,
        isFetchingQuote: false,
        selectedPrice: quote.recommendedPrice,
      );
    } catch (error) {
      debugPrint('Failed to fetch hailing quote: $error');
      state = state.copyWith(
        isFetchingQuote: false,
        errorMessage: error.toString(),
        selectedPrice: null,
      );
    }
  }

  Future<void> _subscribeToRideUpdates(String rideId) async {
    _unsubscribeFromRideUpdates();

    final String? token = await _authStorageService.getAccessToken();
    if (token == null) {
      debugPrint('Unable to subscribe to ride updates: missing token');
      return;
    }

    await _socketService.ensureConnected(token);
    _socketService.trackRide(rideId: rideId, onEvent: updateRideFromEvent);
    _trackedRideId = rideId;
  }

  void _unsubscribeFromRideUpdates() {
    if (_trackedRideId == null) return;
    _socketService.untrackRide(_trackedRideId!);
    _trackedRideId = null;
  }

  Future<bool> requestRide() async {
    final RouteInfo? routeInfo = state.routeInfo;
    final double? price = state.selectedPrice;

    if (routeInfo == null || price == null || price <= 0) {
      state = state.copyWith(
        errorMessage: 'Missing price or route information',
      );
      return false;
    }

    state = state.copyWith(isRequestingRide: true, errorMessage: null);

    try {
      final double estimatedMinutes = routeInfo.duration.inSeconds / 60.0;

      final ride = await _logisticsRepository.createHailingRequest(
        price: price,
        distanceKm: routeInfo.distanceKm,
        estimatedTimeMinutes: estimatedMinutes,
      );

      final ridePrice = ride.price ?? price;

      state = state.copyWith(
        isRequestingRide: false,
        activeRide: ride.copyWith(price: ridePrice),
        selectedPrice: ridePrice,
        stage: _stageForRideStatus(ride.status),
      );

      await _subscribeToRideUpdates(ride.id);

      return true;
    } catch (error) {
      debugPrint('Failed to create hailing request: $error');
      state = state.copyWith(
        isRequestingRide: false,
        errorMessage: error.toString(),
      );
      return false;
    }
  }

  Future<bool> completeRide({String? completionToken}) async {
    final RideRequest? ride = state.activeRide;
    if (ride == null) return false;

    state = state.copyWith(isCompletingRide: true, errorMessage: null);

    try {
      final updated = await _logisticsRepository.updateHailingRequest(
        ride.id,
        status: RideStatus.completed.apiValue,
        initiatedBy: 'rider',
        completionToken: completionToken,
      );

      final mergedRide = ride.copyWith(
        status: updated.status,
        driverId: updated.driverId ?? ride.driverId,
        reachedDestination:
            updated.reachedDestination ?? ride.reachedDestination,
      );

      state = state.copyWith(
        isCompletingRide: false,
        activeRide: mergedRide,
        stage: _stageForRideStatus(updated.status),
      );
      return true;
    } catch (error) {
      debugPrint('Failed to complete ride: $error');
      state = state.copyWith(
        isCompletingRide: false,
        errorMessage: error.toString(),
      );
      return false;
    }
  }

  void resetRideFlow() {
    _unsubscribeFromRideUpdates();
    state = state.copyWith(
      stage: LogisticsStage.initial,
      activeRide: null,
      isRequestingRide: false,
      isCompletingRide: false,
      quote: null,
      selectedPrice: null,
      errorMessage: null,
    );
  }

  void updateRideFromEvent(RideRequest ride) {
    final RideRequest? currentRide = state.activeRide;
    if (currentRide != null && currentRide.id != ride.id) {
      return;
    }

    final RideRequest merged = (currentRide ?? ride).copyWith(
      status: ride.status,
      price: ride.price ?? currentRide?.price,
      driverId: ride.driverId ?? currentRide?.driverId,
      reachedDestination:
          ride.reachedDestination ?? currentRide?.reachedDestination,
    );

    state = state.copyWith(
      activeRide: merged,
      stage: _stageForRideStatus(merged.status),
    );

    if (merged.status == RideStatus.completed ||
        merged.status == RideStatus.canceled) {
      _unsubscribeFromRideUpdates();
    }
  }

  LogisticsStage _stageForRideStatus(RideStatus status) {
    switch (status) {
      case RideStatus.requested:
        return LogisticsStage.lookingForDriver;
      case RideStatus.accepted:
        return LogisticsStage.waitingForDriver;
      case RideStatus.arrived:
        return LogisticsStage.driverArrived;
      case RideStatus.inProgress:
        return LogisticsStage.inProgress;
      case RideStatus.completed:
        return LogisticsStage.complete;
      case RideStatus.canceled:
        return LogisticsStage.confirmRequest;
    }
  }
}
