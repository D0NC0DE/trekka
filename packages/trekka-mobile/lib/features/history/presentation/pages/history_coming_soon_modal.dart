import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';
import 'package:trekka/core/assets/app_assets.dart';

/// Displays a placeholder modal until the history feature is ready.
class HistoryComingSoonModal extends StatelessWidget {
  const HistoryComingSoonModal({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return CenterModalSheet(
      dismissible: false,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      topButton: Image.asset(AppAssetIcons.historyTab, width: 24, height: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              letterSpacing: 1.6,
              color: AppColors.accentAmber,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: AppColors.white75),
          ),
        ],
      ),
    );
  }
}
