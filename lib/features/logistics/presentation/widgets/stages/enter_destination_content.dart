import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/icon_text_button.dart';
import 'package:trekka/core/widgets/connector/route_connector.dart';
import 'package:trekka/core/widgets/input/location_search_field.dart';
import 'package:trekka/features/logistics/presentation/providers/logistics_provider.dart';
import 'package:trekka/features/logistics/presentation/widgets/place_suggestion.dart';
import 'package:trekka/features/logistics/utils/address_formatter.dart';

/// Content for the enter destination stage
class EnterDestinationContent extends ConsumerStatefulWidget {
  const EnterDestinationContent({required this.onNext, super.key});

  final VoidCallback onNext;

  @override
  ConsumerState<EnterDestinationContent> createState() =>
      _EnterDestinationContentState();
}

class _EnterDestinationContentState
    extends ConsumerState<EnterDestinationContent> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      // Ensure address is fetched (will use cache if valid)
      ref.read(logisticsViewModelProvider.notifier).fetchUserAddress();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
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
    final displayText = logisticsState.userAddress != null
        ? AddressFormatter.shortenAddress(logisticsState.userAddress!)
        : 'Your location';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Text(
            'Enter a destination',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: AppColors.white),
          ),
        ),
        const SizedBox(height: AppSpacing.mdLg),

        IconTextButton(
          text: displayText,
          leadingIcon: AppAssetIcons.riderMarker,
          textColor: AppColors.textPrimary50,
          onPressed: null, // Disabled for now
        ),
        const RouteConnector(),

        LocationSearchField(
          controller: _controller,
          focusNode: _focusNode,
          hintText: 'Where to go?',
          readOnly: false,
          autofocus: true,
          onChanged: _onSearchChanged,
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
                  'Select Destination on map',
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

        if (logisticsState.predictions.isNotEmpty) ...[
          PlaceSuggestion(
            logisticsState: logisticsState,
            controller: _controller,
            onPredictionSelected: widget.onNext,
            onSelectPrediction: ref
                .read(logisticsViewModelProvider.notifier)
                .selectPrediction,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
