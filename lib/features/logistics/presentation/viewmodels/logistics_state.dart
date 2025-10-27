import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// State for logistics journey flow
class LogisticsState extends Equatable {
  const LogisticsState({
    this.userLocation,
    this.userAddress,
    this.cachedAddressLocation,
    this.destinationLocation,
    this.destinationAddress,
    this.isFetchingUserAddress = false,
  });

  final LatLng? userLocation;
  final String? userAddress;
  final LatLng? cachedAddressLocation; // Location the address was fetched for
  final LatLng? destinationLocation;
  final String? destinationAddress;
  final bool isFetchingUserAddress;

  LogisticsState copyWith({
    LatLng? userLocation,
    String? userAddress,
    LatLng? cachedAddressLocation,
    LatLng? destinationLocation,
    String? destinationAddress,
    bool? isFetchingUserAddress,
  }) {
    return LogisticsState(
      userLocation: userLocation ?? this.userLocation,
      userAddress: userAddress ?? this.userAddress,
      cachedAddressLocation: cachedAddressLocation ?? this.cachedAddressLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      isFetchingUserAddress:
          isFetchingUserAddress ?? this.isFetchingUserAddress,
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
  ];
}
