import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/core/widgets/input/app_multiline_text_field.dart';

class CompleteRideContent extends StatefulWidget {
  const CompleteRideContent({required this.onComplete, super.key});

  final VoidCallback onComplete;

  @override
  State<CompleteRideContent> createState() => _CompleteRideContentState();
}

class _CompleteRideContentState extends State<CompleteRideContent> {
  int _rating = 0;
  final Set<String> _selectedReviews = {};
  final TextEditingController _commentController = TextEditingController();

  final List<String> _quickReviews = [
    'Nice driver',
    'Rude',
    'Late',
    'Poor driving',
    'Clean vehicle',
    'Unsafe',
    'Professional',
    'Helpful',
  ];

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_onCommentChanged);
  }

  @override
  void dispose() {
    _commentController.removeListener(_onCommentChanged);
    _commentController.dispose();
    super.dispose();
  }

  void _onCommentChanged() {
    setState(() {
      // Rebuild to update button state when text changes
    });
  }

  void _toggleReview(String review) {
    setState(() {
      if (_selectedReviews.contains(review)) {
        _selectedReviews.remove(review);
      } else {
        _selectedReviews.add(review);
      }
    });
  }

  bool get _hasProvidedFeedback =>
      _selectedReviews.isNotEmpty || _commentController.text.trim().isNotEmpty;

  bool get _canSubmit => _rating > 0 && _hasProvidedFeedback;

  void _handleSubmitTap() {
    if (_canSubmit) {
      widget.onComplete();
    } else {
      _showFeedbackMessage();
    }
  }

  void _showFeedbackMessage() {
    String message;
    
    if (_rating == 0 && !_hasProvidedFeedback) {
      message = 'Please rate your driver and share your experience. You\'ll both earn rewards! 🎁';
    } else if (_rating == 0) {
      message = 'Please rate your driver to continue. Earn rewards together! ⭐';
    } else {
      message = 'Please share your experience with a quick review or comment. Both get rewards! 💬';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
              ),
        ),
        backgroundColor: AppColors.deepTeal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        gradient: AppGradients.completeRideBackground,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: AppSizes.completeRideSuccessBadge,
                height: AppSizes.completeRideSuccessBadge,
                decoration: const BoxDecoration(
                  color: AppColors.completeRideSuccessBadge,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.completeRideSuccessBadge,
                ),
                clipBehavior: Clip.hardEdge,
                child: Center(
                  child: Image.asset(
                    AppAssetIcons.success,
                    width: 42,
                    height: 31,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              // Success message with exact specifications
              Text(
                'Ride completed successfully!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: AppFontWeights.semiBold,
                  height: 1.2,
                  letterSpacing: 0,
                  color: AppColors.white,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Star rating - 5 stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = starIndex;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      child: Icon(
                        _rating >= starIndex ? Icons.star : Icons.star_border,
                        size: AppSizes.completeRideStarSize,
                        color: _rating >= starIndex
                            ? AppColors.accentAmber
                            : AppColors.white50,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppSpacing.md),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick reviews',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _quickReviews.map((review) {
                  final isSelected = _selectedReviews.contains(review);
                  return GestureDetector(
                    onTap: () => _toggleReview(review),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        review,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textPrimary,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.md),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Additional comments (optional)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              AppMultilineTextField(
                controller: _commentController,
                maxLines: AppSizes.completeRideTextFieldLines.toInt(),
                hintText: 'Share more details about your experience...',
              ),
              const SizedBox(height: AppSpacing.lg),

              SizedBox(
                width: double.infinity,
                child: GradientActionButton(
                  label: 'Submit rating',
                  onTap: _handleSubmitTap,
                  isActive: _canSubmit,
                  gradient: _canSubmit
                      ? AppGradients.completeRideButtonActive
                      : AppGradients.completeRideButtonInactive,
                  borderColor: _canSubmit
                      ? AppColors.primaryBright
                      : AppColors.logisticsActionInactive,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
