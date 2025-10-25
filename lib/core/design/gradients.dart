import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

class AppGradients {
  AppGradients._();

  static const Gradient homeAuthSheet = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.transparentGraphite,
      AppColors.midnightGreen,
    ],
    stops: <double>[0, 0.6399],
  );

  static const Gradient logisticsBottomSheet = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.tealGradientStart,
      AppColors.tealGradientEnd,
    ],
  );

  static const Gradient logisticsActionButton = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.primaryBright,
      AppColors.tealDark,
    ],
  );

  static const Gradient backButton = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      AppColors.tealBrightGradientStart,
      AppColors.tealBrightGradientEnd,
    ],
  );
}
