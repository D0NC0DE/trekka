import 'package:trekka/features/logistics/domain/entities/hailing_quote.dart';

/// DTO that maps the logistics hailing quote response to a domain entity.
class HailingQuoteDto {
  const HailingQuoteDto({
    required this.currency,
    required this.recommendedPrice,
    required this.breakdown,
  });

  final String currency;
  final double recommendedPrice;
  final HailingQuoteBreakdownDto breakdown;

  factory HailingQuoteDto.fromJson(Map<String, dynamic> json) {
    return HailingQuoteDto(
      currency: json['currency'] as String? ?? 'NGN',
      recommendedPrice: (json['recommendedPrice'] as num).toDouble(),
      breakdown: HailingQuoteBreakdownDto.fromJson(
        json['breakdown'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
    );
  }

  HailingQuote toEntity() {
    return HailingQuote(
      currency: currency,
      recommendedPrice: recommendedPrice,
      breakdown: breakdown.toEntity(),
    );
  }
}

/// DTO for nested quote breakdown fields.
class HailingQuoteBreakdownDto {
  const HailingQuoteBreakdownDto({
    required this.baseComponent,
    required this.distanceComponent,
    required this.timeComponent,
    required this.surgeMultiplier,
    required this.vehicleMultiplier,
    required this.extras,
    required this.priorityFee,
    required this.subtotalBeforeFees,
    required this.serviceFee,
    required this.totalBeforeRounding,
    required this.roundedTotal,
  });

  final double baseComponent;
  final double distanceComponent;
  final double timeComponent;
  final double surgeMultiplier;
  final double vehicleMultiplier;
  final double extras;
  final double priorityFee;
  final double subtotalBeforeFees;
  final double serviceFee;
  final double totalBeforeRounding;
  final double roundedTotal;

  factory HailingQuoteBreakdownDto.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value, [double fallback = 0]) {
      if (value == null) return fallback;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? fallback;
      return fallback;
    }

    return HailingQuoteBreakdownDto(
      baseComponent: parseDouble(json['baseComponent']),
      distanceComponent: parseDouble(json['distanceComponent']),
      timeComponent: parseDouble(json['timeComponent']),
      surgeMultiplier: parseDouble(json['surgeMultiplier'], 1),
      vehicleMultiplier: parseDouble(json['vehicleMultiplier'], 1),
      extras: parseDouble(json['extras']),
      priorityFee: parseDouble(json['priorityFee']),
      subtotalBeforeFees: parseDouble(json['subtotalBeforeFees']),
      serviceFee: parseDouble(json['serviceFee']),
      totalBeforeRounding: parseDouble(json['totalBeforeRounding']),
      roundedTotal: parseDouble(json['roundedTotal']),
    );
  }

  HailingQuoteBreakdown toEntity() {
    return HailingQuoteBreakdown(
      baseComponent: baseComponent,
      distanceComponent: distanceComponent,
      timeComponent: timeComponent,
      surgeMultiplier: surgeMultiplier,
      vehicleMultiplier: vehicleMultiplier,
      extras: extras,
      priorityFee: priorityFee,
      subtotalBeforeFees: subtotalBeforeFees,
      serviceFee: serviceFee,
      totalBeforeRounding: totalBeforeRounding,
      roundedTotal: roundedTotal,
    );
  }
}
