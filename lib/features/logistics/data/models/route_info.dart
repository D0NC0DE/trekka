/// Result from Google Routes API containing distance and duration
class RouteInfo {
  const RouteInfo({
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final int distanceMeters;
  final int durationSeconds;

  Duration get duration => Duration(seconds: durationSeconds);

  double get distanceKm => distanceMeters / 1000;

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    final routes = json['routes'] as List?;
    if (routes == null || routes.isEmpty) {
      throw Exception('No routes found in response');
    }

    final route = routes[0] as Map<String, dynamic>;

    final distanceMeters = route['distanceMeters'] as int?;

    final durationStr = route['duration'] as String?;

    if (distanceMeters == null || durationStr == null) {
      throw Exception('Missing distance or duration in route response');
    }

    final durationSeconds = int.parse(durationStr.replaceAll('s', ''));

    return RouteInfo(
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
    );
  }
}
