import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

class AppGradients {
  AppGradients._();

  static const Gradient homeAuthSheet = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.transparentGraphite, AppColors.midnightGreen],
    stops: <double>[0, 0.6399],
  );

  static const Gradient logisticsSheet = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.tealGradientStart, AppColors.tealGradientEnd],
  );

  static const Gradient centerModal = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.centerModalGradientStart,
      AppColors.centerModalGradientEnd,
    ],
  );

  static const Gradient logisticsActionButton = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.primaryBright, AppColors.tealDark],
  );

  static const Gradient logisticsSearchIcon = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.logisticsIconStart, AppColors.logisticsIconEnd],
  );

  static const Gradient backButton = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.tealBrightGradientStart,
      AppColors.tealBrightGradientEnd,
    ],
  );

  static const Gradient completeRideBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.tealGradientStart, AppColors.tealGradientEnd],
  );

  static const Gradient completeRideButtonActive = LinearGradient(
    colors: <Color>[
      AppColors.tealBrightGradientStart,
      AppColors.tealBrightGradientEnd,
    ],
  );

  static const Gradient completeRideButtonInactive = LinearGradient(
    colors: <Color>[
      AppColors.logisticsActionInactive,
      AppColors.logisticsActionInactive,
    ],
  );

  static const Gradient marketplaceHighlight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.marketplaceHighlightStart,
      AppColors.marketplaceHighlightEnd,
    ],
  );

  static const Gradient marketplaceInput = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[AppColors.white, AppColors.marketplaceInputBase],
  );

  static const Gradient marketplaceLoading = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.marketplaceLoadingStart,
      AppColors.marketplaceLoadingEnd,
    ],
  );

  static const Gradient marketplaceCard = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.white25,
      AppColors.marketplaceInputHighlight,
    ],
  );
}
