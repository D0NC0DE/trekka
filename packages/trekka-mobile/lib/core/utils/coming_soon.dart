import 'package:flutter/material.dart';

import 'package:trekka/core/widgets/snackbar/app_snackbar.dart';

/// Shows a standard "coming soon" snackbar message.
void showComingSoon(BuildContext context, {String? featureLabel}) {
  final String displayLabel = featureLabel?.trim() ?? '';
  final bool hasLabel = displayLabel.isNotEmpty;
  final String message = hasLabel
      ? '$displayLabel is coming soon.'
      : 'Coming soon.';

  AppSnackbar.showInfo(context, message);
}
