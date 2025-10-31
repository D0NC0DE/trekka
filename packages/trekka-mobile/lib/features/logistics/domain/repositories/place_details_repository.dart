import 'package:trekka/features/logistics/data/models/place_details.dart';

/// Contract for retrieving detailed place information.
abstract class PlaceDetailsRepository {
  Future<PlaceDetails?> getPlaceDetails(String placeId);
}
