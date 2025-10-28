import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/auth/presentation/widgets/auth_sheet.dart';

/// Prompts unauthenticated users to log in from the profile modal.
class ProfileUnauthenticatedContent extends StatelessWidget {
  const ProfileUnauthenticatedContent({this.errorMessage, super.key});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage ?? 'Log in to view and manage your Trekka profile.',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: AppColors.white75),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => AuthSheet.show(context),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.smLg,
              ),
            ),
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }
}
