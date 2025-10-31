import 'package:trekka/features/logistics/data/datasources/logistics_remote_datasource.dart';
import 'package:trekka/features/logistics/data/models/hailing_quote_dto.dart';
import 'package:trekka/features/logistics/data/models/ride_request_dto.dart';
import 'package:trekka/features/logistics/domain/entities/hailing_quote.dart';
import 'package:trekka/features/logistics/domain/entities/ride_request.dart';
import 'package:trekka/features/logistics/domain/repositories/logistics_repository.dart';

/// Concrete implementation for logistics hailing operations.
class LogisticsRepositoryImpl implements LogisticsRepository {
  const LogisticsRepositoryImpl(this._datasource);

  final LogisticsRemoteDataSource _datasource;

  @override
  Future<HailingQuote> fetchHailingQuote({
    required double distanceKm,
    required double estimatedTimeMinutes,
    String? vehicleClass,
    double? extras,
    bool? priority,
  }) async {
    final Map<String, dynamic> json = await _datasource.fetchHailingQuote(
      distanceKm: distanceKm,
      estimatedTimeMinutes: estimatedTimeMinutes,
      vehicleClass: vehicleClass,
      extras: extras,
      priority: priority,
    );

    return HailingQuoteDto.fromJson(json).toEntity();
  }

  @override
  Future<RideRequest> createHailingRequest({
    required double price,
    required double distanceKm,
    required double estimatedTimeMinutes,
  }) async {
    final Map<String, dynamic> json = await _datasource.createHailingRequest(
      price: price,
      distanceKm: distanceKm,
      estimatedTimeMinutes: estimatedTimeMinutes,
    );

    return RideRequestDto.fromJson(json).toEntity();
  }

  @override
  Future<RideRequest> updateHailingRequest(
    String rideId, {
    String? status,
    String? initiatedBy,
    String? canceledBy,
    String? reason,
    String? completionToken,
    String? pinCode,
  }) async {
    final Map<String, dynamic> json = await _datasource.updateHailingRequest(
      rideId,
      status: status,
      initiatedBy: initiatedBy,
      canceledBy: canceledBy,
      reason: reason,
      completionToken: completionToken,
      pinCode: pinCode,
    );

    return RideRequestDto.fromJson(json).toEntity();
  }

  @override
  Future<RideRequest> getHailingRequest(String rideId) async {
    final Map<String, dynamic> json = await _datasource.getHailingRequest(
      rideId,
    );
    return RideRequestDto.fromJson(json).toEntity();
  }
}
