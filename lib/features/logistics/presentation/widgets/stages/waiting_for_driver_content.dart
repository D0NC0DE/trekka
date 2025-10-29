import 'package:flutter/material.dart';
import 'package:trekka/core/design/shadows.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/utils/coming_soon.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';
import 'package:trekka/features/logistics/presentation/widgets/common/bottom_border_card.dart';
import 'package:trekka/features/logistics/presentation/widgets/common/gradient_icon_button.dart';

class WaitingForDriverContent extends StatelessWidget {
  const WaitingForDriverContent({
    required this.onAction,
    this.actionLabel = 'Cancel ride',
    super.key,
  });

  final VoidCallback onAction;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        BottomBorderCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const _DriverAvatar(),
                  const _DriverRating(rating: 4, totalStars: 5),
                  Text(
                    '128 reviews',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      height: 20 / 12,
                      fontSize: AppSpacing.smLg,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'TREKKA DRIVER',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: AppFontWeights.semiBold,
                      height: 1.25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.smLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: AppSpacing.md,
                      children: <Widget>[
                        GradientIconButton(
                          iconPath: AppAssetIcons.chat,
                          iconWidth: 18,
                          iconHeight: 18,
                          onTap: () =>
                              showComingSoon(context, featureLabel: 'Chat'),
                        ),
                        GradientIconButton(
                          iconPath: AppAssetIcons.call,
                          iconWidth: 18,
                          iconHeight: 18,
                          onTap: () =>
                              showComingSoon(context, featureLabel: 'Call'),
                        ),
                        GradientIconButton(
                          iconPath: AppAssetIcons.popDots,
                          iconWidth: 18,
                          iconHeight: 18,
                          onTap: () =>
                              showComingSoon(context, featureLabel: 'Actions'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              AppAssetIcons.ride,
                              width: 29,
                              height: 13,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'AKJ 234 FK',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.white,
                                fontWeight: AppFontWeights.semiBold,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Toyota Corolla 2021',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.white,
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        GradientActionButton(label: actionLabel, onTap: onAction),
      ],
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.logisticsActionInactive,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.logisticsDriverAvatarBorder,
          width: 2,
        ),
        boxShadow: AppShadows.avatarBorderShadow,
      ),
      alignment: Alignment.center,
      child: Icon(Icons.person, color: AppColors.midnightGreen, size: 28),
    );
  }
}

// TODO: we fetch the rating from the backend.
class _DriverRating extends StatelessWidget {
  const _DriverRating({required this.rating, required this.totalStars});

  final int rating;
  final int totalStars;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(totalStars, (index) {
        final bool isFilled = index < rating;
        return Padding(
          padding: EdgeInsets.only(right: index == totalStars - 1 ? 0 : 4),
          child: Image.asset(
            AppAssetIcons.star,
            width: 12,
            height: 12,
            color: isFilled
                ? AppColors.logisticsActionActive
                : AppColors.logisticsActionInactive,
          ),
        );
      }),
    );
  }
}
