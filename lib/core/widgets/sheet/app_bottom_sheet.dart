import 'package:flutter/material.dart';

class AppBottomSheet {
  /// Shows a non-modal bottom sheet with consistent app-wide styling and behavior.
  /// 
  /// Non-modal sheets allow interaction with the rest of the screen.
  ///
  /// [context] - The build context (must have a Scaffold ancestor)
  /// [child] - The content widget to display in the sheet
  /// [maxHeightFactor] - Maximum height as a fraction of screen height (0.0 to 1.0)
  static PersistentBottomSheetController show({
    required BuildContext context,
    required Widget child,
    double maxHeightFactor = 0.5,
  }) {
    assert(
      maxHeightFactor > 0.0 && maxHeightFactor <= 1.0,
      'maxHeightFactor must be between 0.0 and 1.0',
    );

    final Size size = MediaQuery.of(context).size;
    final double maxHeight = size.height * maxHeightFactor;

    return showBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (BuildContext sheetContext) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: IntrinsicHeight(
            child: child,
          ),
        );
      },
    );
  }
}
