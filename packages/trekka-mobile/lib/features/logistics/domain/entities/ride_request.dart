/// Possible statuses for a ride request returned by the logistics backend.
enum RideStatus {
  requested,
  accepted,
  arrived,
  inProgress,
  completed,
  canceled,
}

extension RideStatusX on RideStatus {
  /// Status string expected by the backend when updating a ride.
  String get apiValue {
    switch (this) {
      case RideStatus.requested:
        return 'requested';
      case RideStatus.accepted:
        return 'accepted';
      case RideStatus.arrived:
        return 'arrived';
      case RideStatus.inProgress:
        return 'in_progress';
      case RideStatus.completed:
        return 'completed';
      case RideStatus.canceled:
        return 'canceled';
    }
  }
}

/// Convert a backend status string to [RideStatus].
RideStatus rideStatusFromString(String raw) {
  switch (raw) {
    case 'accepted':
      return RideStatus.accepted;
    case 'arrived':
      return RideStatus.arrived;
    case 'in_progress':
      return RideStatus.inProgress;
    case 'completed':
      return RideStatus.completed;
    case 'canceled':
      return RideStatus.canceled;
    case 'requested':
    default:
      return RideStatus.requested;
  }
}

/// Represents the active ride request created by the rider.
class RideRequest {
  const RideRequest({
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

  RideRequest copyWith({
    RideStatus? status,
    double? price,
    String? driverId,
    bool? reachedDestination,
  }) {
    return RideRequest(
      id: id,
      status: status ?? this.status,
      price: price ?? this.price,
      driverId: driverId ?? this.driverId,
      reachedDestination: reachedDestination ?? this.reachedDestination,
    );
  }
}
