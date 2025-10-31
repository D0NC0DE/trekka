import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/domain/entities/hailing_quote.dart';
import 'package:trekka/features/logistics/domain/entities/logistics_stage.dart';
import 'package:trekka/features/logistics/domain/entities/ride_request.dart';
import 'package:trekka/features/logistics/data/models/place_autocomplete_prediction.dart';
import 'package:trekka/features/logistics/data/models/route_info.dart';

/// State for logistics journey flow
class LogisticsState extends Equatable {
  static const Object _unset = Object();

  const LogisticsState({
    this.stage = LogisticsStage.initial,
    this.userLocation,
    this.userAddress,
    this.cachedAddressLocation,
    this.destinationLocation,
    this.destinationAddress,
    this.isFetchingUserAddress = false,
    this.predictions = const [],
    this.isFetchingPredictions = false,
    this.routeInfo,
    this.isFetchingRoute = false,
    this.isFetchingQuote = false,
    this.quote,
    this.selectedPrice,
    this.isRequestingRide = false,
    this.activeRide,
    this.isCompletingRide = false,
    this.errorMessage,
  });

  final LogisticsStage stage;
  final LatLng? userLocation;
  final String? userAddress;
  final LatLng? cachedAddressLocation; // Location the address was fetched for
  final LatLng? destinationLocation;
  final String? destinationAddress;
  final bool isFetchingUserAddress;
  final List<PlaceAutocompletePrediction> predictions;
  final bool isFetchingPredictions;
  final RouteInfo? routeInfo;
  final bool isFetchingRoute;
  final bool isFetchingQuote;
  final HailingQuote? quote;
  final double? selectedPrice;
  final bool isRequestingRide;
  final RideRequest? activeRide;
  final bool isCompletingRide;
  final String? errorMessage;

  LogisticsState copyWith({
    Object? stage = _unset,
    Object? userLocation = _unset,
    Object? userAddress = _unset,
    Object? cachedAddressLocation = _unset,
    Object? destinationLocation = _unset,
    Object? destinationAddress = _unset,
    bool? isFetchingUserAddress,
    Object? predictions = _unset,
    bool? isFetchingPredictions,
    Object? routeInfo = _unset,
    bool? isFetchingRoute,
    bool? isFetchingQuote,
    Object? quote = _unset,
    Object? selectedPrice = _unset,
    bool? isRequestingRide,
    Object? activeRide = _unset,
    bool? isCompletingRide,
    Object? errorMessage = _unset,
  }) {
    return LogisticsState(
      stage: identical(stage, _unset) ? this.stage : stage as LogisticsStage,
      userLocation: identical(userLocation, _unset)
          ? this.userLocation
          : userLocation as LatLng?,
      userAddress: identical(userAddress, _unset)
          ? this.userAddress
          : userAddress as String?,
      cachedAddressLocation: identical(cachedAddressLocation, _unset)
          ? this.cachedAddressLocation
          : cachedAddressLocation as LatLng?,
      destinationLocation: identical(destinationLocation, _unset)
          ? this.destinationLocation
          : destinationLocation as LatLng?,
      destinationAddress: identical(destinationAddress, _unset)
          ? this.destinationAddress
          : destinationAddress as String?,
      isFetchingUserAddress:
          isFetchingUserAddress ?? this.isFetchingUserAddress,
      predictions: identical(predictions, _unset)
          ? this.predictions
          : predictions as List<PlaceAutocompletePrediction>,
      isFetchingPredictions:
          isFetchingPredictions ?? this.isFetchingPredictions,
      routeInfo: identical(routeInfo, _unset)
          ? this.routeInfo
          : routeInfo as RouteInfo?,
      isFetchingRoute: isFetchingRoute ?? this.isFetchingRoute,
      isFetchingQuote: isFetchingQuote ?? this.isFetchingQuote,
      quote: identical(quote, _unset) ? this.quote : quote as HailingQuote?,
      selectedPrice: identical(selectedPrice, _unset)
          ? this.selectedPrice
          : selectedPrice as double?,
      isRequestingRide: isRequestingRide ?? this.isRequestingRide,
      activeRide: identical(activeRide, _unset)
          ? this.activeRide
          : activeRide as RideRequest?,
      isCompletingRide: isCompletingRide ?? this.isCompletingRide,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    stage,
    userLocation,
    userAddress,
    cachedAddressLocation,
    destinationLocation,
    destinationAddress,
    isFetchingUserAddress,
    predictions,
    isFetchingPredictions,
    routeInfo,
    isFetchingRoute,
    isFetchingQuote,
    quote,
    selectedPrice,
    isRequestingRide,
    activeRide,
    isCompletingRide,
    errorMessage,
  ];
}
