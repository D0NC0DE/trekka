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
    final distance = distanceMeters;

    if (distance == null) {
      return '<1 m';
    }

    if (distance <= 0) {
      return '<1 m';
    }

    if (distance >= 1000) {
      final kmValue = distance / 1000;
      final kmLabel = kmValue >= 10
          ? kmValue.toStringAsFixed(0)
          : kmValue.toStringAsFixed(1);
      return '$kmLabel km';
    }

    if (distance >= 100) {
      return '$distance m';
    }

    final feet = (distance * 3.28084).round();
    if (feet <= 3) {
      return '<1 m';
    }
    return '$feet ft';
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
