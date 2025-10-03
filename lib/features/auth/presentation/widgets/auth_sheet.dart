import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/app_bottom_sheet.dart';
import 'package:trekka/core/widgets/sheet_container.dart';
import 'package:trekka/core/widgets/sheet_drag_handle.dart';
import 'package:trekka/features/auth/presentation/widgets/auth_divider.dart';
import 'package:trekka/features/auth/presentation/widgets/social_login_buttons.dart';

class AuthSheet extends StatelessWidget {
  const AuthSheet({super.key});

  /// Show auth modal from anywhere in the app.
  static Future<void> show(
    BuildContext context, {
    bool isDismissible = true,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: const AuthSheet(),
      heightFactor: 0.8,
      isDismissible: isDismissible,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetContainer(
      backgroundImage: AppAssetImages.authSheetBackground,
      gradient: AppGradients.homeAuthSheet,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: AppSpacing.md),
            const SheetDragHandle(),
            const SizedBox(height: 55),
            Image.asset(
              AppAssetIcons.trekkaAnimated,
              width: 170,
              height: 139,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 50),
            const SocialLoginButtons(),
            const SizedBox(height: AppSpacing.xxl),
            const AuthDivider(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

