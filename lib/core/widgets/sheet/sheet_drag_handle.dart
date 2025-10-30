import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

/// A standard drag handle indicator for bottom sheets.
class SheetDragHandle extends StatelessWidget {
  const SheetDragHandle({
    this.width = 130,
    this.height = 4,
    this.color = AppColors.divider,
    super.key,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

