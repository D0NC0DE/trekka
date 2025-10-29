import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

/// A themed linear progress indicator with gradient colors.
class LinearLoader extends StatelessWidget {
  const LinearLoader({
    this.width,
    this.height = 4,
    this.borderRadius,
    super.key,
  });

  final double? width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? height / 2),
      ),
      child: const LinearProgressIndicator(
        backgroundColor: AppColors.white25,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBright),
      ),
    );
  }
}

/// A centered linear loader with optional message.
class CenteredLinearLoader extends StatelessWidget {
  const CenteredLinearLoader({
    this.message,
    this.width = 200,
    super.key,
  });

  final String? message;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearLoader(width: width),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.white75,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

