import 'package:equatable/equatable.dart';

/// Represents a place prediction from Google Places Autocomplete
class PlaceAutocompletePrediction extends Equatable {
  const PlaceAutocompletePrediction({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    required this.fullText,
    this.types = const [],
    this.distanceMeters,
  });

  factory PlaceAutocompletePrediction.fromJson(Map<String, dynamic> json) {
    final placePrediction = json['placePrediction'] as Map<String, dynamic>;
    final structuredFormat =
        placePrediction['structuredFormat'] as Map<String, dynamic>;

    return PlaceAutocompletePrediction(
      placeId: placePrediction['placeId'] as String,
      mainText:
          (structuredFormat['mainText'] as Map<String, dynamic>)['text']
              as String,
      secondaryText:
          (structuredFormat['secondaryText'] as Map<String, dynamic>)['text']
              as String,
      fullText:
          (placePrediction['text'] as Map<String, dynamic>)['text'] as String,
      types:
          (placePrediction['types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      distanceMeters: placePrediction['distanceMeters'] as int?,
    );
  }

  final String placeId;
  final String mainText;
  final String secondaryText;
  final String fullText;
  final List<String> types;
  final int? distanceMeters;

  /// Format distance for display
  String? get formattedDistance {
    if (distanceMeters == null) return null;

    if (distanceMeters! < 1000) {
      return '$distanceMeters m';
    } else {
      final km = (distanceMeters! / 1000).toStringAsFixed(1);
      return '$km km';
    }
  }

  @override
  List<Object?> get props => [
    placeId,
    mainText,
    secondaryText,
    fullText,
    types,
    distanceMeters,
  ];
}
