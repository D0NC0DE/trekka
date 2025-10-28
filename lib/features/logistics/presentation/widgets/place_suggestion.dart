import 'package:flutter/material.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/logistics/data/models/place_autocomplete_prediction.dart';
import 'package:trekka/features/logistics/presentation/viewmodels/logistics_state.dart';

class PlaceSuggestion extends StatelessWidget {
  const PlaceSuggestion({
    super.key,
    required this.logisticsState,
    required TextEditingController controller,
    required this.onPredictionSelected,
    required this.onSelectPrediction,
  }) : _controller = controller;

  final LogisticsState logisticsState;
  final TextEditingController _controller;
  final VoidCallback onPredictionSelected;
  final Future<void> Function(PlaceAutocompletePrediction) onSelectPrediction;

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
              onTap: () async {
                _controller.text = prediction.fullText;
                FocusScope.of(context).unfocus();
                onSelectPrediction(prediction);
                onPredictionSelected();
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
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontWeight: AppFontWeights.semiBold,
                                        color: AppColors.white,
                                      ),
                                ),
                              ),
                              Text(
                                prediction.formattedDistance ?? '',
                                style: Theme.of(context).textTheme.labelSmall
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
                            style: Theme.of(context).textTheme.bodySmall
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
