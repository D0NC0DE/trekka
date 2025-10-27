import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/features/logistics/data/datasources/geocoding_datasource.dart';
import 'package:trekka/features/logistics/data/datasources/place_details_datasource.dart';
import 'package:trekka/features/logistics/data/datasources/places_autocomplete_datasource.dart';
import 'package:trekka/features/logistics/data/repositories/geocoding_repository_impl.dart';
import 'package:trekka/features/logistics/data/repositories/place_details_repository_impl.dart';
import 'package:trekka/features/logistics/data/repositories/places_autocomplete_repository_impl.dart';
import 'package:trekka/features/logistics/domain/repositories/geocoding_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/place_details_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/places_autocomplete_repository.dart';

final geocodingDatasourceProvider = Provider<GeocodingDatasource>((ref) {
  return GeocodingDatasource();
});

final geocodingRepositoryProvider = Provider<GeocodingRepository>((ref) {
  final datasource = ref.read(geocodingDatasourceProvider);
  return GeocodingRepositoryImpl(datasource);
});

final placesAutocompleteDatasourceProvider =
    Provider<PlacesAutocompleteDatasource>((ref) {
      return PlacesAutocompleteDatasource();
    });

final placesAutocompleteRepositoryProvider =
    Provider<PlacesAutocompleteRepository>((ref) {
      final datasource = ref.read(placesAutocompleteDatasourceProvider);
      return PlacesAutocompleteRepositoryImpl(datasource: datasource);
    });

final placeDetailsDatasourceProvider = Provider<PlaceDetailsDatasource>((ref) {
  return PlaceDetailsDatasource();
});

final placeDetailsRepositoryProvider = Provider<PlaceDetailsRepository>((ref) {
  final datasource = ref.read(placeDetailsDatasourceProvider);
  return PlaceDetailsRepositoryImpl(datasource: datasource);
});
