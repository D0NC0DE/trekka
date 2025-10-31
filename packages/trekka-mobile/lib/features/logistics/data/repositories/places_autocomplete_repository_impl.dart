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
    String? regionCode,
  }) {
    final requestRegionCode = regionCode?.toUpperCase();

    return datasource
        .getPlacePredictions(
          input: input,
          origin: origin,
          regionCode: requestRegionCode,
        )
        .then((predictions) {
          final sortedPredictions = [...predictions]
            ..sort((a, b) {
              final distanceA = a.distanceMeters ?? 0;
              final distanceB = b.distanceMeters ?? 0;
              return distanceA.compareTo(distanceB);
            });
          return sortedPredictions;
        });
  }
}
