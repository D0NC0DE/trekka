import 'package:trekka/core/network/api_client.dart';
import 'package:trekka/core/network/api_constants.dart';

/// Remote datasource for interacting with logistics hailing endpoints.
class LogisticsRemoteDataSource {
  const LogisticsRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> fetchHailingQuote({
    required double distanceKm,
    required double estimatedTimeMinutes,
    String? vehicleClass,
    double? extras,
    bool? priority,
  }) {
    return _apiClient.post(
      ApiConstants.logisticsHailingQuotes,
      data: <String, dynamic>{
        'distanceKm': distanceKm,
        'estimatedTimeMinutes': estimatedTimeMinutes,
        if (vehicleClass != null) 'vehicleClass': vehicleClass,
        if (extras != null) 'extras': extras,
        if (priority != null) 'priority': priority,
      },
    );
  }

  Future<Map<String, dynamic>> createHailingRequest({
    required double price,
    required double distanceKm,
    required double estimatedTimeMinutes,
  }) {
    return _apiClient.post(
      ApiConstants.logisticsHailingRequests,
      data: <String, dynamic>{
        'price': price,
        'distance_km': distanceKm,
        'estimated_time_minutes': estimatedTimeMinutes,
      },
    );
  }

  Future<Map<String, dynamic>> updateHailingRequest(
    String rideId, {
    String? status,
    String? initiatedBy,
    String? canceledBy,
    String? reason,
    String? completionToken,
    String? pinCode,
  }) {
    return _apiClient.patch(
      '${ApiConstants.logisticsHailingRequests}/$rideId',
      data: <String, dynamic>{
        if (status != null) 'status': status,
        if (initiatedBy != null) 'initiated_by': initiatedBy,
        if (canceledBy != null) 'canceled_by': canceledBy,
        if (reason != null) 'reason': reason,
        if (completionToken != null) 'completion_token': completionToken,
        if (pinCode != null) 'pin_code': pinCode,
      },
    );
  }

  Future<Map<String, dynamic>> getHailingRequest(String rideId) {
    return _apiClient.get('${ApiConstants.logisticsHailingRequests}/$rideId');
  }
}
