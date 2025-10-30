import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/datasources/routes_datasource.dart';
import 'package:trekka/features/logistics/data/models/route_info.dart';
import 'package:trekka/features/logistics/domain/repositories/routes_repository.dart';

/// Implementation of RoutesRepository
class RoutesRepositoryImpl implements RoutesRepository {
  RoutesRepositoryImpl(this._datasource);

  final RoutesDatasource _datasource;

  @override
  Future<RouteInfo?> getRouteInfo({
    required LatLng origin,
    required LatLng destination,
    String travelMode = 'DRIVE',
  }) async {
    try {
      final result = await _datasource.computeRoute(
        originLat: origin.latitude.toString(),
        originLng: origin.longitude.toString(),
        destinationLat: destination.latitude.toString(),
        destinationLng: destination.longitude.toString(),
        travelMode: travelMode,
      );

      return RouteInfo.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }
}
