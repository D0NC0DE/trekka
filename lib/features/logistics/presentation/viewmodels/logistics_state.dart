import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/models/place_autocomplete_prediction.dart';

/// State for logistics journey flow
class LogisticsState extends Equatable {
  const LogisticsState({
    this.userLocation,
    this.userAddress,
    this.cachedAddressLocation,
    this.destinationLocation,
    this.destinationAddress,
    this.isFetchingUserAddress = false,
    this.predictions = const [],
    this.isFetchingPredictions = false,
  });

  final LatLng? userLocation;
  final String? userAddress;
  final LatLng? cachedAddressLocation; // Location the address was fetched for
  final LatLng? destinationLocation;
  final String? destinationAddress;
  final bool isFetchingUserAddress;
  final List<PlaceAutocompletePrediction> predictions;
  final bool isFetchingPredictions;

  LogisticsState copyWith({
    LatLng? userLocation,
    String? userAddress,
    LatLng? cachedAddressLocation,
    LatLng? destinationLocation,
    String? destinationAddress,
    bool? isFetchingUserAddress,
    List<PlaceAutocompletePrediction>? predictions,
    bool? isFetchingPredictions,
  }) {
    return LogisticsState(
      userLocation: userLocation ?? this.userLocation,
      userAddress: userAddress ?? this.userAddress,
      cachedAddressLocation: cachedAddressLocation ?? this.cachedAddressLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      isFetchingUserAddress:
          isFetchingUserAddress ?? this.isFetchingUserAddress,
      predictions: predictions ?? this.predictions,
      isFetchingPredictions: isFetchingPredictions ?? this.isFetchingPredictions,
    );
  }

  @override
  List<Object?> get props => [
    userLocation,
    userAddress,
    cachedAddressLocation,
    destinationLocation,
    destinationAddress,
    isFetchingUserAddress,
    predictions,
    isFetchingPredictions,
  ];
}
