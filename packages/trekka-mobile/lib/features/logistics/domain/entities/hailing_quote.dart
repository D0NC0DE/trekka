/// Represents a calculated hailing quote returned from the backend.
class HailingQuote {
  const HailingQuote({
    required this.currency,
    required this.recommendedPrice,
    required this.breakdown,
  });

  final String currency;
  final double recommendedPrice;
  final HailingQuoteBreakdown breakdown;
}

/// Detailed breakdown for a hailing quote.
class HailingQuoteBreakdown {
  const HailingQuoteBreakdown({
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
}
