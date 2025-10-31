import 'package:trekka/features/logistics/domain/entities/hailing_quote.dart';
import 'package:trekka/features/logistics/domain/entities/ride_request.dart';

/// Abstraction over logistics hailing operations.
abstract class LogisticsRepository {
  Future<HailingQuote> fetchHailingQuote({
    required double distanceKm,
    required double estimatedTimeMinutes,
    String? vehicleClass,
    double? extras,
    bool? priority,
  });

  Future<RideRequest> createHailingRequest({
    required double price,
    required double distanceKm,
    required double estimatedTimeMinutes,
  });

  Future<RideRequest> updateHailingRequest(
    String rideId, {
    String? status,
    String? initiatedBy,
    String? canceledBy,
    String? reason,
    String? completionToken,
    String? pinCode,
  });

  Future<RideRequest> getHailingRequest(String rideId);
}
