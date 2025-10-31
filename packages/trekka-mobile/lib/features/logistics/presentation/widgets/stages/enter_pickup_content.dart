import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/utils/coming_soon.dart';
import 'package:trekka/core/widgets/button/icon_text_button.dart';
import 'package:trekka/core/widgets/connector/route_connector.dart';
import 'package:trekka/core/widgets/input/location_search_field.dart';
import 'package:trekka/features/logistics/presentation/providers/logistics_provider.dart';
import 'package:trekka/features/logistics/presentation/widgets/place_suggestion.dart';
import 'package:trekka/features/logistics/utils/address_formatter.dart';

/// Content for editing pickup location manually.
class EnterPickupLocationContent extends ConsumerStatefulWidget {
  const EnterPickupLocationContent({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  ConsumerState<EnterPickupLocationContent> createState() =>
      _EnterPickupLocationContentState();
}

class _EnterPickupLocationContentState
    extends ConsumerState<EnterPickupLocationContent> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pickupAddress = ref.read(logisticsViewModelProvider).userAddress;
      final initialText = pickupAddress != null
          ? AddressFormatter.shortenAddress(pickupAddress)
          : '';
      _controller
        ..text = initialText
        ..selection = TextSelection.collapsed(offset: initialText.length);
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();

    if (value.trim().isEmpty) {
      ref.read(logisticsViewModelProvider.notifier).clearPredictions();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      ref.read(logisticsViewModelProvider.notifier).searchPlaces(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final logisticsState = ref.watch(logisticsViewModelProvider);
    final destinationSummary = logisticsState.destinationAddress != null
        ? AddressFormatter.formatWithFallback(
            logisticsState.destinationAddress!,
            'Fetching destination...',
          )
        : 'Destination not set';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Text(
            'Edit pickup location',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: AppColors.white),
          ),
        ),
        const SizedBox(height: AppSpacing.mdLg),
        LocationSearchField(
          controller: _controller,
          focusNode: _focusNode,
          hintText: 'Pickup address',
          readOnly: false,
          autofocus: true,
          onChanged: _onSearchChanged,
        ),
        const RouteConnector(),
        IconTextButton(
          text: destinationSummary,
          leadingIcon: AppAssetIcons.destinationInfo,
          textColor: AppColors.textPrimary50,
          onPressed: null,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (logisticsState.isFetchingPredictions) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              minHeight: 4,
              backgroundColor: AppColors.white25,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.logisticsActionActive,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () =>
                showComingSoon(context, featureLabel: 'Select pickup on map'),
            child: Row(
              children: <Widget>[
                Image.asset(
                  AppAssetIcons.selectOnMap,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Select pickup on map',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.logisticsActionActive,
                      height: 1.25,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ),
                Image.asset(
                  AppAssetIcons.stop,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),

        if (logisticsState.predictions.isNotEmpty) ...[
          PlaceSuggestion(
            logisticsState: logisticsState,
            controller: _controller,
            onPredictionSelected: widget.onNext,
            onSelectPrediction: ref
                .read(logisticsViewModelProvider.notifier)
                .selectPickupPrediction,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
