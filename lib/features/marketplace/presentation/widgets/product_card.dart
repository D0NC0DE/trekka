import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.imageAsset,
    required this.title,
    required this.price,
    this.location,
    super.key,
  });

  const ProductCard.skeleton({super.key})
    : imageAsset = '',
      title = 'Product Name Placeholder',
      price = '\$99.99',
      location = null;

  final String imageAsset;
  final String title;
  final String price;
  final String? location;

  static const double _cardRadius = AppRadius.sm; // 8px

  @override
  Widget build(BuildContext context) {
    final bool isSkeleton = imageAsset.isEmpty;

    return Skeletonizer(
      enabled: false,
      enableSwitchAnimation: true,
      effect: ShimmerEffect(
        baseColor: AppColors.marketplaceLoadingEnd,
        highlightColor: AppColors.marketplaceLoadingStart,
        duration: const Duration(milliseconds: 1000),
      ),
      child: SizedBox(
        height: 240,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.marketplaceCard,
            borderRadius: BorderRadius.circular(_cardRadius),
            border: const Border(
              bottom: BorderSide(
                color: AppColors.marketplaceCardBorder,
                width: 1,
              ),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 170,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(_cardRadius),
                    topRight: Radius.circular(_cardRadius),
                  ),
                  child: isSkeleton
                      ? Bone.square(size: double.infinity)
                      : Image.asset(
                          imageAsset,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.black,
                        fontWeight: AppFontWeights.semiBold,
                        height: 1.0,
                        fontSize: AppSpacing.smLg,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      price,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
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
  }
}
