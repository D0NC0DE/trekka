import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/features/logistics/presentation/providers/logistics_provider.dart';
import 'package:trekka/features/logistics/presentation/widgets/common/bottom_border_card.dart';
import 'package:trekka/features/logistics/presentation/widgets/common/gradient_icon_button.dart';
import 'package:trekka/features/logistics/utils/address_formatter.dart';

/// Content for the confirm pickup location stage.
class ConfirmPickupLocationContent extends ConsumerWidget {
  const ConfirmPickupLocationContent({required this.onConfirm, super.key});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logisticsState = ref.watch(logisticsViewModelProvider);

    final pickupAddress = AddressFormatter.formatWithFallback(
      logisticsState.userAddress,
      'Fetching pickup...',
    );
    final destinationAddress = AddressFormatter.formatWithFallback(
      logisticsState.destinationAddress,
      'Fetching destination...',
    );
    final (String pickupPrimary, String? pickupSecondary) = _splitAddressParts(
      pickupAddress,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _PickupAddressCard(
          iconPath: AppAssetIcons.riderMarker,
          primaryText: pickupPrimary,
          secondaryText: pickupSecondary,
          trailing: const GradientIconButton(iconPath: AppAssetIcons.search),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SizedBox(height: AppSpacing.lg),
        GradientActionButton(label: 'Confirm pickup', onTap: onConfirm),
      ],
    );
  }

  (String, String?) _splitAddressParts(String address) {
    final segments = address.split(',');
    if (segments.length <= 1) {
      final trimmed = address.trim();
      return (trimmed, null);
    }

    final primary = segments.first.trim();
    final remainder = segments.skip(1).join(',').trim();
    return (primary, remainder.isEmpty ? null : remainder);
  }
}

class _PickupAddressCard extends StatelessWidget {
  const _PickupAddressCard({
    required this.iconPath,
    required this.primaryText,
    required this.secondaryText,
    this.trailing,
  });

  final String iconPath;
  final String primaryText;
  final String? secondaryText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomBorderCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(iconPath, width: 16, height: 16, fit: BoxFit.contain),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  primaryText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (secondaryText != null &&
                    secondaryText!.isNotEmpty) ...<Widget>[
                  Text(
                    secondaryText!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      height: 20 / 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}
