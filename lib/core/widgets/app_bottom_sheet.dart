import 'package:flutter/material.dart';

/// A reusable bottom sheet wrapper that provides consistent behavior across the app.
///
/// Features:
/// - Tap outside to dismiss
/// - Keyboard-aware (adjusts for keyboard insets)
/// - Configurable height
/// - Transparent background with custom content
class AppBottomSheet {
  /// Shows a bottom sheet with consistent app-wide styling and behavior.
  ///
  /// [context] - The build context
  /// [child] - The content widget to display in the sheet
  /// [heightFactor] - The height as a fraction of screen height (0.0 to 1.0)
  /// [isDismissible] - Whether tapping outside dismisses the sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double heightFactor = 0.8,
    bool isDismissible = true,
  }) {
    assert(
      heightFactor > 0.0 && heightFactor <= 1.0,
      'heightFactor must be between 0.0 and 1.0',
    );

    final Size size = MediaQuery.of(context).size;
    final double sheetHeight = size.height * heightFactor;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      builder: (BuildContext sheetContext) {
        final double bottomInset = MediaQuery.of(
          sheetContext,
        ).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Stack(
            children: <Widget>[
              if (isDismissible)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(sheetContext).pop(),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: sheetHeight,
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

