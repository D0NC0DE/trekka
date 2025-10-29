import 'package:flutter/material.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_label_button.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

class PostProduct extends StatelessWidget {
  const PostProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      borderRadius: BorderRadius.circular(AppRadius.xs),
      shadows: AppShadows.buttonInner,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.smLg,
          vertical: AppSpacing.smMd,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sell faster, post your product!',
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(
                    color: AppColors.marketplaceHighlight,
                    fontWeight: AppFontWeights.semiBold,
                    height: 20 / 14,
                  ),
            ),
            GradientLabelButton(
              label: 'Post item',
              onTap: () {},
              borderRadius: 2,
              gradient: AppGradients.marketplaceHighlight,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(
                    fontSize: AppSpacing.smMd,
                    color: AppColors.primary,
                    fontWeight: AppFontWeights.semiBold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
