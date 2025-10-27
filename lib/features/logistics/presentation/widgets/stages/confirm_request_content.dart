import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/connector/route_connector.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/features/logistics/presentation/providers/logistics_provider.dart';
import 'package:trekka/features/logistics/presentation/widgets/common/bottom_border_card.dart';
import 'package:trekka/features/logistics/presentation/widgets/common/gradient_icon_button.dart';
import 'package:trekka/features/logistics/utils/address_formatter.dart';

/// Review card showing pickup and drop-off summary before confirming request.
class ConfirmRequestContent extends ConsumerStatefulWidget {
  const ConfirmRequestContent({super.key});

  @override
  ConsumerState<ConfirmRequestContent> createState() =>
      _ConfirmRequestContentState();
}

class _ConfirmRequestContentState extends ConsumerState<ConfirmRequestContent> {
  // TODO: Get from backend
  static const double _priceStep = 50;
  static const double _initialPrice = 4500;
  static const int _numberOfPassengers = 4;

  late final TextEditingController _priceController;
  late final FocusNode _priceFocusNode;
  double _currentPrice = _initialPrice;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: _formatPrice(_initialPrice));
    _priceFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  String _formatPrice(double value) => '₦${value.toStringAsFixed(0)}';

  void _updatePrice(double value) {
    setState(() {
      _currentPrice = value.clamp(0, double.infinity);
      _priceController
        ..text = _formatPrice(_currentPrice)
        ..selection = TextSelection.collapsed(
          offset: _priceController.text.length,
        );
    });
  }

  void _handleDecrease() {
    _updatePrice((_currentPrice - _priceStep).clamp(0, double.infinity));
  }

  void _handleIncrease() {
    _updatePrice(_currentPrice + _priceStep);
  }

  void _handlePriceChanged(String value) {
    final numeric = value.replaceAll(RegExp(r'[^0-9.]'), '');
    if (numeric.isEmpty) {
      _updatePrice(0);
      return;
    }

    final parsed = double.tryParse(numeric);
    if (parsed != null) {
      _updatePrice(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        const Padding(
          padding: EdgeInsets.only(left: AppSpacing.smLg, top: AppSpacing.sm),
          child: RouteConnector(position: Alignment.centerLeft),
        ),
        _SummaryCard(
          title: 'Drop off point',
          address: destinationAddress,
          iconPath: AppAssetIcons.destinationInfo,
        ),
        // const SizedBox(height: AppSpacing.smLg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _VehicleInfoButton(numberOfPassengers: _numberOfPassengers),
            const SizedBox(width: AppSpacing.smLg),
            Expanded(
              child: _PriceAdjuster(
                controller: _priceController,
                focusNode: _priceFocusNode,
                onDecrease: _handleDecrease,
                onIncrease: _handleIncrease,
                onChanged: _handlePriceChanged,
                suggestedLabel:
                    'Suggested price: ${_formatPrice(_initialPrice)}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.smLg),
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

class _VehicleInfoButton extends StatelessWidget {
  const _VehicleInfoButton({required this.numberOfPassengers});
  final int numberOfPassengers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomBorderCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            AppAssetIcons.ride,
            width: 65,
            height: 26,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                AppAssetIcons.seat,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$numberOfPassengers Pax',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceAdjuster extends StatelessWidget {
  const _PriceAdjuster({
    required this.controller,
    required this.focusNode,
    required this.onDecrease,
    required this.onIncrease,
    required this.onChanged,
    required this.suggestedLabel,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final ValueChanged<String> onChanged;
  final String suggestedLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.smLg),
      decoration: BoxDecoration(
        color: AppColors.reduceActionBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.reduceActionShadow,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GradientIconButton(
            iconPath: AppAssetIcons.reduce,
            width: 32,
            height: 32,
            borderRadius: 16,
            iconWidth: 16,
            iconHeight: 16,
            onTap: onDecrease,
          ),
          const SizedBox(width: AppSpacing.smLg),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.midnightGreen,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        onChanged: onChanged,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => focusNode.requestFocus(),
                      child: Image.asset(
                        AppAssetIcons.edit,
                        width: 12,
                        height: 12,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  suggestedLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.midnightGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.smLg),
          GradientIconButton(
            iconPath: AppAssetIcons.increase,
            width: 32,
            height: 32,
            borderRadius: 16,
            iconWidth: 16,
            iconHeight: 16,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }
}
