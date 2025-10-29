import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/features/logistics/presentation/providers/logistics_provider.dart';
import 'package:trekka/features/logistics/presentation/widgets/common/bottom_border_card.dart';
import 'package:trekka/features/logistics/presentation/widgets/common/gradient_icon_button.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';
import 'package:trekka/features/logistics/utils/address_formatter.dart';

/// Content for the confirm pickup location stage.
class ConfirmPickupLocationContent extends ConsumerWidget {
  const ConfirmPickupLocationContent({
    required this.onConfirm,
    required this.onEditPickup,
    super.key,
  });

  final VoidCallback onConfirm;
  final VoidCallback onEditPickup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logisticsState = ref.watch(logisticsViewModelProvider);

    final pickupAddress = AddressFormatter.formatWithFallback(
      logisticsState.userAddress,
      'Fetching pickup...',
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
          onEditPickup: onEditPickup,
        ),
        const SizedBox(height: AppSpacing.sm),
        _JourneyMetricsCard(
          distanceLabel: 'Total Distance',
          distanceValue: _resolveDistanceDisplay(logisticsState),
          timeLabel: 'Estimated Time',
          timeValue: _resolveDurationDisplay(logisticsState),
        ),
        const SizedBox(height: AppSpacing.lg),
        GradientActionButton(
          label: 'Confirm current location',
          onTap: onConfirm,
        ),
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

  String _resolveDistanceDisplay(LogisticsState state) {
    if (state.isFetchingRoute) {
      return 'Calculating...';
    }

    if (state.routeInfo != null) {
      final distanceKm = state.routeInfo!.distanceKm;
      return '${distanceKm.toStringAsFixed(1)} km';
    }

    return 'N/A';
  }

  String _resolveDurationDisplay(LogisticsState state) {
    if (state.isFetchingRoute) {
      return 'Calculating...';
    }

    if (state.routeInfo != null) {
      final duration = state.routeInfo!.duration;
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);

      if (hours > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${minutes}m';
    }

    return 'N/A';
  }
}

class _PickupAddressCard extends StatelessWidget {
  const _PickupAddressCard({
    required this.iconPath,
    required this.primaryText,
    required this.secondaryText,
    required this.onEditPickup,
  });

  final String iconPath;
  final String primaryText;
  final String? secondaryText;
  final VoidCallback onEditPickup;

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
          const SizedBox(width: AppSpacing.sm),
          GradientIconButton(
            iconPath: AppAssetIcons.searchWhite,
            onTap: onEditPickup,
            iconWidth: 16,
            iconHeight: 16,
          ),
        ],
      ),
    );
  }
}

class _JourneyMetricsCard extends StatelessWidget {
  const _JourneyMetricsCard({
    required this.distanceLabel,
    required this.distanceValue,
    required this.timeLabel,
    required this.timeValue,
  });

  final String distanceLabel;
  final String distanceValue;
  final String timeLabel;
  final String timeValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Text buildLabel(String text) {
      return Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
          height: 20 / 14,
        ),
      );
    }

    Text buildValue(String text) {
      return Text(
        text,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: AppColors.white,
          fontWeight: AppFontWeights.semiBold,
        ),
      );
    }

    return BottomBorderCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildLabel(distanceLabel),
                const SizedBox(height: AppSpacing.xs),
                buildValue(distanceValue),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                buildLabel(timeLabel),
                const SizedBox(height: AppSpacing.xs),
                buildValue(timeValue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
