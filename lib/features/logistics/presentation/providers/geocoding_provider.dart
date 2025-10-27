import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/features/logistics/data/datasources/geocoding_datasource.dart';
import 'package:trekka/features/logistics/data/datasources/places_autocomplete_datasource.dart';
import 'package:trekka/features/logistics/data/repositories/geocoding_repository_impl.dart';
import 'package:trekka/features/logistics/data/repositories/places_autocomplete_repository_impl.dart';
import 'package:trekka/features/logistics/domain/repositories/geocoding_repository.dart';
import 'package:trekka/features/logistics/domain/repositories/places_autocomplete_repository.dart';

final geocodingDatasourceProvider = Provider<GeocodingDatasource>((ref) {
  return GeocodingDatasource();
});

final geocodingRepositoryProvider = Provider<GeocodingRepository>((ref) {
  final datasource = ref.read(geocodingDatasourceProvider);
  return GeocodingRepositoryImpl(datasource);
});

final placesAutocompleteDatasourceProvider = Provider<PlacesAutocompleteDatasource>((ref) {
  return PlacesAutocompleteDatasource();
});

final placesAutocompleteRepositoryProvider = Provider<PlacesAutocompleteRepository>((ref) {
  final datasource = ref.read(placesAutocompleteDatasourceProvider);
  return PlacesAutocompleteRepositoryImpl(datasource: datasource);
});
