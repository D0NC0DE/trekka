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
}
