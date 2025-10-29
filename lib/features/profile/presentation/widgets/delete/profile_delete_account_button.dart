import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

/// Button that triggers the account deletion confirmation modal.
class ProfileDeleteAccountButton extends StatelessWidget {
  const ProfileDeleteAccountButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: AppColors.deleteButtonBorder,
                width: 0.5,
              ),
            ),
            child: Text(
              'Delete Account',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                height: 1.25,
                fontWeight: AppFontWeights.regular,
                color: AppColors.destructive,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
