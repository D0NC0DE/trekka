import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/icon_text_button.dart';
import 'package:trekka/core/widgets/connector/route_connector.dart';
import 'package:trekka/core/widgets/input/location_search_field.dart';
import 'package:trekka/features/logistics/presentation/providers/logistics_provider.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';

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

  String _shortenAddress(String address) {
    final parts = address.split(',');
    if (parts.length > 2) {
      return '${parts[0]}, ${parts[1].trim()}';
    }
    return address;
  }

  @override
  Widget build(BuildContext context) {
    final logisticsState = ref.watch(logisticsViewModelProvider);
    final displayText = logisticsState.userAddress != null
        ? _shortenAddress(logisticsState.userAddress!)
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
          PlaceSuggestion(logisticsState: logisticsState, controller: _controller, ref: ref),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class PlaceSuggestion extends StatelessWidget {
  const PlaceSuggestion({
    super.key,
    required this.logisticsState,
    required TextEditingController controller,
    required this.ref,
  }) : _controller = controller;

  final LogisticsState logisticsState;
  final TextEditingController _controller;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      clipBehavior: Clip.hardEdge,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: AppSpacing.sm),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: logisticsState.predictions.length,
        itemBuilder: (context, index) {
          final prediction = logisticsState.predictions[index];
          final isLast = index == logisticsState.predictions.length - 1;
    
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _controller.text = prediction.fullText;
                ref
                    .read(logisticsViewModelProvider.notifier)
                    .selectPrediction(prediction);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isLast
                          ? Colors.transparent
                          : const Color(0x40D9D9D9),
                      width: 1,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: AppColors.logisticsActionInactive,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  prediction.mainText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: AppFontWeights.semiBold,
                                        color: AppColors.white,
                                      ),
                                ),
                              ),
                              Text(
                                prediction.formattedDistance ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppColors.logisticsActionInactive,
                                      fontWeight: AppFontWeights.medium,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            prediction.secondaryText,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.logisticsActionInactive,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
