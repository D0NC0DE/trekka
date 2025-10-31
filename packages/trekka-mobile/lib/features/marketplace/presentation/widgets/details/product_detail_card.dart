import 'package:flutter/material.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/marketplace/presentation/pages/product_detail_page.dart';
import 'package:trekka/features/marketplace/presentation/widgets/details/product_actions.dart';

class ProductDetailCard extends StatelessWidget {
  const ProductDetailCard({
    super.key,
    required this.widget,
  });

  final MarketplaceProductDetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.marketplaceCard,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: const Border(
          bottom: BorderSide(
            color: AppColors.marketplaceCardBorder,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: AppFontWeights.semiBold,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.product.price,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppFontWeights.bold,
                ),
          ),
          if (widget.product.location != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 18,
                  color: AppColors.textPrimary50,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    widget.product.location!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color: AppColors.textPrimary50,
                        ),
                  ),
                ),
              ],
            ),
          ],
          if (widget.product.description != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: AppFontWeights.semiBold,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.product.description!,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          ProductActions()
        ],
      ),
    );
  }
}
