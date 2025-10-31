import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/logistics/domain/entities/logistics_stage.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';

class MapPolylineBuilder {
  MapPolylineBuilder._();

  static Set<Polyline> buildPolylines({
    required LogisticsState logisticsState,
    required LogisticsStage currentStage,
  }) {
    if (!_shouldShowPolyline(currentStage)) {
      return <Polyline>{};
    }

    if (logisticsState.routeInfo?.encodedPolyline == null) {
      return <Polyline>{};
    }

    final List<LatLng>? polylinePoints = logisticsState.routeInfo!
        .decodePolyline();

    if (polylinePoints == null || polylinePoints.isEmpty) {
      return <Polyline>{};
    }

    return <Polyline>{
      Polyline(
        polylineId: const PolylineId('route'),
        points: polylinePoints,
        color: AppColors.primaryBright,
        width: 5,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }

  static bool _shouldShowPolyline(LogisticsStage stage) {
    return stage == LogisticsStage.confirmRequest ||
        stage == LogisticsStage.lookingForDriver ||
        stage == LogisticsStage.waitingForDriver ||
        stage == LogisticsStage.driverArrived ||
        stage == LogisticsStage.inProgress;
  }
}
