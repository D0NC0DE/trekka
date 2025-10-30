import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/marketplace/domain/entities/marketplace_product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    this.onTap,
    this.isLoading = false,
    super.key,
  });

  final MarketplaceProduct product;
  final VoidCallback? onTap;
  final bool isLoading;

  static const double _cardRadius = AppRadius.sm; // 8px

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      enableSwitchAnimation: true,
      effect: ShimmerEffect(
        baseColor: AppColors.marketplaceLoadingEnd,
        highlightColor: AppColors.marketplaceLoadingStart,
        duration: const Duration(milliseconds: 1000),
      ),
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
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
                  child: _buildCoverImage(),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.title,
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
                        product.price,
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
      ),
    );
  }

  Widget _buildCoverImage() {
    final Widget imageContent = ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(_cardRadius),
        topRight: Radius.circular(_cardRadius),
      ),
      child: isLoading
          ? Bone.square(size: double.infinity)
          : Image.asset(
              product.coverImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
    );

    if (isLoading || product.coverImage.isEmpty) {
      return imageContent;
    }

    return Hero(tag: product.heroTag, child: imageContent);
  }
}
