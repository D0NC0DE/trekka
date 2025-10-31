import 'package:trekka/features/logistics/domain/entities/ride_request.dart';

/// DTO that maps ride request responses to the domain entity.
class RideRequestDto {
  const RideRequestDto({
    required this.id,
    required this.status,
    this.price,
    this.driverId,
    this.reachedDestination,
  });

  final String id;
  final RideStatus status;
  final double? price;
  final String? driverId;
  final bool? reachedDestination;

  factory RideRequestDto.fromJson(Map<String, dynamic> json) {
    double? parsePrice(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return RideRequestDto(
      id: json['id'] as String,
      status: rideStatusFromString(json['status'] as String? ?? 'requested'),
      price: parsePrice(json['price']),
      driverId: json['driverId'] as String?,
      reachedDestination: json['reachedDestination'] as bool?,
    );
  }

  RideRequest toEntity() {
    return RideRequest(
      id: id,
      status: status,
      price: price,
      driverId: driverId,
      reachedDestination: reachedDestination,
    );
  }
}
