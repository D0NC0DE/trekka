import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/connector/route_connector.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/features/logistics/presentation/providers/logistics_provider.dart';
import 'package:trekka/features/logistics/presentation/widgets/common/bottom_border_card.dart';
import 'package:trekka/features/logistics/utils/address_formatter.dart';

/// Review card showing pickup and drop-off summary before confirming request.
class ConfirmRequestContent extends ConsumerWidget {
  const ConfirmRequestContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(logisticsViewModelProvider);
    final pickupAddress = AddressFormatter.formatWithFallback(
      state.userAddress,
      'Fetching pickup...',
    );
    final destinationAddress = AddressFormatter.formatWithFallback(
      state.destinationAddress,
      'Fetching destination...',
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _SummaryCard(
          title: 'Pickup point',
          address: pickupAddress,
          iconPath: AppAssetIcons.riderMarker,
        ),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.smLg, top: AppSpacing.sm),
          child: const RouteConnector(position: Alignment.centerLeft,),
        ),
        _SummaryCard(
          title: 'Drop off point',
          address: destinationAddress,
          iconPath: AppAssetIcons.destinationInfo,
        ),
        const SizedBox(height: AppSpacing.lg),
        GradientActionButton(label: 'Confirm ride', onTap: () {}),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.address,
    required this.iconPath,
  });

  final String title;
  final String address;
  final String iconPath;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomBorderCard(
      child: Row(
        children: [
          Image.asset(iconPath, width: 16, height: 16, fit: BoxFit.contain),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    height: 20 / 14,
                  ),
                ),
                Text(
                  AddressFormatter.shortenAddress(address),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
