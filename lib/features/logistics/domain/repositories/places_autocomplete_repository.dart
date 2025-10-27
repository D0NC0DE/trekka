import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/models/place_autocomplete_prediction.dart';

/// Abstract contract for places autocomplete operations
abstract class PlacesAutocompleteRepository {
  Future<List<PlaceAutocompletePrediction>> getPlacePredictions({
    required String input,
    LatLng? origin,
    LatLng? locationCenter,
    double radiusMeters = 50000.0,
    String? regionCode,
  });
}
