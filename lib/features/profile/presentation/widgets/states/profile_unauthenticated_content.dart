import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/sheet/center_modal_sheet.dart';
import 'package:trekka/features/auth/presentation/widgets/auth_sheet.dart';

/// Prompts unauthenticated users to log in from the profile modal.
class ProfileUnauthenticatedContent extends StatelessWidget {
  const ProfileUnauthenticatedContent({this.errorMessage, super.key});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return CenterModalSheet(
      dismissible: false,
      padding: const EdgeInsets.only(top: 50, bottom: 15, left: 35, right: 35),
      topButton: Image.asset(AppAssetIcons.user, width: 24, height: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage ?? 'Log in to view and manage your Trekka profile.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.25,
              fontWeight: AppFontWeights.semiBold,
              color: AppColors.divider,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GradientActionButton(
            label: 'Log In',
            onTap: () => AuthSheet.show(context),
          ),
        ],
      ),
    );
  }
}
