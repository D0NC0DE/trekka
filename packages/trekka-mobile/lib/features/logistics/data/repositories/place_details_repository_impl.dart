import 'package:trekka/features/logistics/data/datasources/place_details_datasource.dart';
import 'package:trekka/features/logistics/data/models/place_details.dart';
import 'package:trekka/features/logistics/domain/repositories/place_details_repository.dart';

/// Implementation of [PlaceDetailsRepository] that uses the remote datasource.
class PlaceDetailsRepositoryImpl implements PlaceDetailsRepository {
  PlaceDetailsRepositoryImpl({required PlaceDetailsDatasource datasource})
    : _datasource = datasource;

  final PlaceDetailsDatasource _datasource;

  @override
  Future<PlaceDetails?> getPlaceDetails(String placeId) {
    return _datasource.fetchPlaceDetails(placeId);
  }
}
