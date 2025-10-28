import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/models/route_info.dart';

/// Abstract repository for Routes API operations
abstract class RoutesRepository {
  Future<RouteInfo?> getRouteInfo({
    required LatLng origin,
    required LatLng destination,
    String travelMode = 'DRIVE',
  });
}
