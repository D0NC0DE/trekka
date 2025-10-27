import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trekka/features/logistics/data/datasources/places_autocomplete_datasource.dart';
import 'package:trekka/features/logistics/data/models/place_autocomplete_prediction.dart';
import 'package:trekka/features/logistics/domain/repositories/places_autocomplete_repository.dart';

/// Implementation of PlacesAutocompleteRepository
class PlacesAutocompleteRepositoryImpl implements PlacesAutocompleteRepository {
  PlacesAutocompleteRepositoryImpl({required this.datasource});

  final PlacesAutocompleteDatasource datasource;

  @override
  Future<List<PlaceAutocompletePrediction>> getPlacePredictions({
    required String input,
    LatLng? origin,
    LatLng? locationCenter,
    double radiusMeters = 50000.0,
    String? regionCode,
  }) {
    return datasource.getPlacePredictions(
      input: input,
      origin: origin,
      locationCenter: locationCenter,
      radiusMeters: radiusMeters,
      regionCode: regionCode,
    );
  }
}
