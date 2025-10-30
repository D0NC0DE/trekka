import 'package:flutter/material.dart';

import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';

/// A container styled for inputs with a gradient background.
class GradientInputContainer extends StatelessWidget {
  const GradientInputContainer({
    required this.onTap,
    this.leading,
    this.child,
    this.placeholder,
    this.borderRadius = 4,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.smLg,
      vertical: AppSpacing.sm,
    ),
    super.key,
  });

  final VoidCallback onTap;
  final Widget? leading;
  final Widget? child;
  final String? placeholder;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  bool get _hasLeading => leading != null;
  bool get _hasChild => child != null;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry resolvedPadding = _hasLeading
        ? EdgeInsets.zero
        : padding;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        gradient: AppGradients.marketplaceInput,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_hasLeading) leading!,
            if (_hasLeading && !_hasChild) const SizedBox(width: AppSpacing.smLg),
            Expanded(
              child: Padding(
                padding: resolvedPadding,
                child: _buildContent(context),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_hasChild) {
      return child!;
    }

    return Text(
      placeholder ?? '',
      style: Theme.of(context).textTheme.bodySmall
          ?.copyWith(
            color: AppColors.textPrimary50,
          ),
    );
  }
}
