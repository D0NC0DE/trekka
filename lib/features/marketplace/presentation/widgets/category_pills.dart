import 'package:flutter/material.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/utils/coming_soon.dart';
import 'package:trekka/core/widgets/button/gradient_label_button.dart';

class CategoryPills extends StatelessWidget {
  const CategoryPills({
    super.key,
    required List<String> categories,
  }) : _categories = categories;

  final List<String> _categories;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((String category) {
          final bool isSelected = category == 'All';
          final bool isLast = category == _categories.last;
          return Padding(
            padding: EdgeInsets.only(
              right: isLast ? 0 : AppSpacing.sm,
            ),
            child: GradientLabelButton(
              label: category,
              onTap: () => showComingSoon(context, featureLabel: 'Select Category'),
              gradient: isSelected ? AppGradients.logisticsActionButton : AppGradients.marketplaceInput,
              textColor: isSelected ? AppColors.white : AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.smLg,
              ),
              borderRadius: AppRadius.sm,
            ),
          );
        }).toList(),
      ),
    );
  }
}
